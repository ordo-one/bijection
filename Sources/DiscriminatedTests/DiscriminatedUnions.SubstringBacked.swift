import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: Substring.self)
    enum SubstringBacked: Equatable {
        case alpha
        case beta(String?)
    }
}
