import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: Substring.self) enum BackedBySubstring: Equatable {
        case alpha
        case beta(String?)
    }
}
