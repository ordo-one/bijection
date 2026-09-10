import SwiftSyntax

extension DiscriminatedMacro {
    struct Case {
        let name: TokenSyntax
    }
}
extension DiscriminatedMacro.Case {
    init(from element: EnumCaseElementSyntax) {
        self.init(name: element.name)
    }
}
