import SwiftSyntax

extension ScopedUnionMacro {
    struct Case {
        let name: TokenSyntax
        let parameters: [TokenSyntax?]
    }
}
extension ScopedUnionMacro.Case {
    init(from element: EnumCaseElementSyntax) {
        let parameters: [TokenSyntax?] = element.parameterClause?.parameters.map {
            if  let label: TokenSyntax = $0.firstName, label.text != "_" {
                return label
            } else {
                return nil
            }
        } ?? []

        self.init(
            name: element.name,
            parameters: parameters
        )
    }
}
