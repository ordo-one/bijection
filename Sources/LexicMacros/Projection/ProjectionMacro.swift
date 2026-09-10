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
                $0.name.text == configuration.through && $0.modifiers.contains {
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

        var projectionCases: [String] = []
        for member: MemberBlockItemSyntax in decl.memberBlock.members {
            guard let enumCase: EnumCaseDeclSyntax = member.decl.as(
                EnumCaseDeclSyntax.self
            ) else {
                continue
            }
            for element: EnumCaseElementSyntax in enumCase.elements {
                guard element.parameterClause?.parameters.count == 1 else {
                    continue
                }
                projectionCases.append(
                    "case .\(element.name)(let scope?): Self.\(configuration.through)(scope)"
                )
            }
        }

        let propertyType: TypeSyntax = if configuration.flatten,
            returnType.is(OptionalTypeSyntax.self) {
            returnType
        } else {
            "\(returnType)?"
        }

        let projectionProperty: DeclSyntax = """
        @inlinable \(decl.modifiers)var \(raw: configuration.through): \(propertyType) {
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
