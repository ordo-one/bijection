import Lexic
import SwiftSyntax
import SwiftSyntaxMacros

struct DiscriminatedMacro {}
extension DiscriminatedMacro {
    static func cases(of decl: EnumDeclSyntax) -> [Case] {
        var cases: [Case] = []
        for member: MemberBlockItemSyntax in decl.memberBlock.members {
            guard let enumCase: EnumCaseDeclSyntax = member.decl.as(
                EnumCaseDeclSyntax.self
            ) else {
                continue
            }
            for element: EnumCaseElementSyntax in enumCase.elements {
                cases.append(.init(from: element))
            }
        }
        return cases
    }
}
extension DiscriminatedMacro: PeerMacro {
    static func expansion(
        of attribute: AttributeSyntax,
        providingPeersOf decl: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard let decl: EnumDeclSyntax = decl.as(EnumDeclSyntax.self) else {
            context[.error, decl] = "'@Discriminated' must be applied to an enum"
            return []
        }

        guard let configuration: Configuration = .init(decoding: attribute, in: context) else {
            return []
        }

        let cases: [Case] = Self.cases(of: decl)
        let casesList: MemberBlockItemListSyntax = .init {
            for `case`: Case in cases {
                EnumCaseDeclSyntax.init(
                    caseKeyword: .keyword(.case, trailingTrivia: .spaces(1))
                ) {
                    EnumCaseElementSyntax.init(
                        name: `case`.name,
                        trailingTrivia: .newlines(1)
                    )
                }
            }
        }

        let attributesOnType: [AttributeListSyntax.Element] = decl.attributes.reduce(into: []) {
            guard
            case .attribute(let attribute) = $1,
            let identifier: IdentifierTypeSyntax = attribute.attributeName.as(
                IdentifierTypeSyntax.self
            ) else {
                return
            }
            switch identifier.name.text {
            case "frozen": break
            case "usableFromInline": break
            default: return
            }

            $0.append($1)
        }

        let inheritance: String = if let backing: TypeSyntax = configuration.backing {
            ": \(backing), CaseIterable, Sendable"
        } else {
            ": CaseIterable, Sendable"
        }

        let peerTypeName: String = configuration.discriminant ?? "\(decl.name.text)Type"
        let peer: DeclSyntax = """
        \(AttributeListSyntax.init(attributesOnType))\
        \(decl.modifiers)enum \(
            raw: peerTypeName
        )\(raw: inheritance) {
        \(casesList)
        }
        """

        return [peer]
    }
}
extension DiscriminatedMacro: MemberMacro {
    static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard let decl: EnumDeclSyntax = decl.as(EnumDeclSyntax.self) else {
            context[.error, decl] = "'@Discriminated' must be applied to an enum"
            return []
        }

        guard let configuration: Configuration = .init(decoding: attribute, in: context) else {
            return []
        }

        let cases: [Case] = Self.cases(of: decl)
        var members: [DeclSyntax] = []

        // 1. Discriminator ‘type’ property
        let peerTypeName: String = configuration.discriminant ?? "\(decl.name.text)Type"
        let typeCases: [String] = cases.map { "case .\($0.name): .\($0.name)" }
        let typeProperty: DeclSyntax = """
        @inlinable \(decl.modifiers)var type: \(raw: peerTypeName) {
            switch self {
            \(raw: typeCases.joined(separator: "\n    "))
            }
        }
        """
        members.append(typeProperty)

        // 2. Static nil-accessors for cases with associated values
        for `case`: Case in cases where !`case`.parameters.isEmpty {
            let arguments: String = `case`.parameters.map {
                if  let label: TokenSyntax = $0 {
                    "\(label.text): nil"
                } else {
                    "nil"
                }
            }.joined(separator: ", ")
            let accessor: DeclSyntax = """
            @inlinable \(decl.modifiers)static var \(raw: `case`.name): Self {
                .\(raw: `case`.name)(\(raw: arguments))
            }
            """
            members.append(accessor)
        }

        // 3. Projections
        for projection: String in configuration.project {
            guard let function: FunctionDeclSyntax = decl.memberBlock.members.compactMap(
                {
                    $0.decl.as(FunctionDeclSyntax.self)
                }
            ).first(
                where: {
                    $0.name.text == projection && $0.modifiers.contains {
                        $0.name.text == "static"
                    }
                }
            ) else {
                context[.error, attribute] = """
                enum '\(decl.name.text)' must declare a 'static func \(
                    projection
                )(_:)' to support projection '\(
                    projection
                )'
                """
                continue
            }

            guard let returnType: TypeSyntax = function.signature.returnClause?.type.trimmed else {
                context[.error, function] = """
                projection function 'static func \(projection)(_:)' must have a return type
                """
                continue
            }

            let projectionCases: [String] = cases.compactMap {
                guard $0.parameters.count == 1 else {
                    return nil
                }
                return "case .\($0.name)(let scope?): Self.\(projection)(scope)"
            }

            let propertyType: TypeSyntax = if configuration.flatten,
                returnType.is(OptionalTypeSyntax.self) {
                returnType
            } else {
                "\(returnType)?"
            }

            let projectionProperty: DeclSyntax = """
            @inlinable \(decl.modifiers)var \(raw: projection): \(propertyType) {
                switch self {
                \(raw: projectionCases.joined(separator: "\n    "))
                default:
                    nil
                }
            }
            """
            members.append(projectionProperty)
        }

        return members
    }
}
