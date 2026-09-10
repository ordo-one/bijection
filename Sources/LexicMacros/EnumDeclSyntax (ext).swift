import SwiftSyntax

extension EnumDeclSyntax {
    var isPublicOrPackage: Bool {
        self.modifiers.contains {
            $0.name.text == "public" || $0.name.text == "package"
        }
    }

    var isUsableFromInline: Bool {
        self.attributes.contains {
            guard case .attribute(let attribute) = $0 else {
                return false
            }
            if  let identifier: IdentifierTypeSyntax = attribute.attributeName.as(
                IdentifierTypeSyntax.self
            ) {
                return identifier.name.text == "usableFromInline"
                    || identifier.name.text == "_usableFromInline"
            }
            if  let member: MemberTypeSyntax = attribute.attributeName.as(
                MemberTypeSyntax.self
            ) {
                return member.name.text == "usableFromInline"
                    || member.name.text == "_usableFromInline"
            }
            return false
        }
    }

    var isInlinable: Bool {
        self.isPublicOrPackage || self.isUsableFromInline
    }

    var inlinable: String {
        self.isInlinable ? "@inlinable " : ""
    }

    var memberModifiers: DeclModifierListSyntax {
        self.modifiers.filter { $0.name.text != "indirect" }
    }
}
