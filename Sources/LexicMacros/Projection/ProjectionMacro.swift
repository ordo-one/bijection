import Lexic
import SwiftSyntax
import SwiftSyntaxMacros

struct ProjectionMacro {}
extension ProjectionMacro: MemberMacro {
    static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard let decl: EnumDeclSyntax = decl.as(EnumDeclSyntax.self) else {
            context[.error, decl] = "'@Projection' must be applied to an enum"
            return []
        }

        guard let configuration: Configuration = .init(decoding: attribute, in: context) else {
            return []
        }

        guard let function: FunctionDeclSyntax = decl.memberBlock.members.compactMap(
            { $0.decl.as(FunctionDeclSyntax.self) }
        ).first(
            where: {
                $0.name.unescaped == configuration.through && $0.modifiers.contains {
                    $0.name.text == "static"
                }
            }
        ) else {
            context[.error, attribute] = """
            enum '\(decl.name.text)' must declare a 'static func \(
                configuration.through
            )(_:)' to support projection '\(
                configuration.through
            )'
            """
            return []
        }

        guard let returnType: TypeSyntax = function.signature.returnClause?.type.trimmed else {
            context[.error, function] = """
            projection function 'static func \(configuration.through)(_:)' \
            must have a return type
            """
            return []
        }

        if returnType.isUnsugaredOptional {
            context[.warning, returnType] = """
            spelling ‘\(returnType.trimmed)’ will not be optimized; \
            use sugared optional ‘?’ instead
            """
        }

        var projectionCases: [String] = []
        for member: MemberBlockItemSyntax in decl.memberBlock.members {
            guard let enumCase: EnumCaseDeclSyntax = member.decl.as(
                EnumCaseDeclSyntax.self
            ) else {
                continue
            }
            for element: EnumCaseElementSyntax in enumCase.elements {
                guard
                let list: EnumCaseParameterListSyntax = element.parameterClause?.parameters,
                    list.count == 1,
                let parameter: EnumCaseParameterSyntax = list.first else {
                    continue
                }

                if parameter.type.isUnsugaredOptional {
                    context[.warning, parameter.type] = """
                    spelling ‘\(parameter.type.trimmed)’ will not be optimized; \
                    use sugared optional ‘?’ instead
                    """
                }

                let pattern: String = if parameter.type.isOptional {
                    "let scope?"
                } else {
                    "let scope"
                }

                projectionCases.append(
                    "case .\(element.name)(\(pattern)): Self.\(configuration.through)(scope)"
                )
            }
        }

        let propertyType: TypeSyntax = if configuration.flatten,
            returnType.isOptional {
            returnType
        } else {
            "\(returnType)?"
        }

        let projectionProperty: DeclSyntax = """
        \(raw: decl.inlinable)\(decl.modifiersForMember)var \
        \(raw: configuration.through): \(propertyType) {
            switch self {
            \(raw: projectionCases.joined(separator: "\n    "))
            default:
                nil
            }
        }
        """

        return [projectionProperty]
    }
}
