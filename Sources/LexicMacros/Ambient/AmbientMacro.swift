import SwiftSyntax
import SwiftSyntaxMacros

struct AmbientMacro {}
extension AmbientMacro: MemberMacro {
    static func expansion(
        of attribute: AttributeSyntax,
        providingMembersOf decl: some DeclGroupSyntax,
        conformingTo _: [TypeSyntax],
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard let decl: EnumDeclSyntax = decl.as(EnumDeclSyntax.self) else {
            context[.error, decl] = "'@ambient' must be applied to an enum"
            return []
        }

        var members: [DeclSyntax] = []

        for member: MemberBlockItemSyntax in decl.memberBlock.members {
            guard let enumCase: EnumCaseDeclSyntax = member.decl.as(
                EnumCaseDeclSyntax.self
            ) else {
                continue
            }
            for element: EnumCaseElementSyntax in enumCase.elements {
                guard
                let parameters: EnumCaseParameterListSyntax = element.parameterClause?.parameters,
                   !parameters.isEmpty else {
                    continue
                }

                let arguments: String = parameters.map {
                    if  let label: TokenSyntax = $0.firstName, label.text != "_" {
                        "\(label.text): nil"
                    } else {
                        "nil"
                    }
                }.joined(separator: ", ")

                let accessor: DeclSyntax = """
                @inlinable \(decl.modifiers)static var \(raw: element.name): Self {
                    .\(raw: element.name)(\(raw: arguments))
                }
                """
                members.append(accessor)
            }
        }

        return members
    }
}
