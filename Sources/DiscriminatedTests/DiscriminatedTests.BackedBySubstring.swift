import Discriminated

extension DiscriminatedTests {
    @Discriminated(backing: Substring.self) enum BackedBySubstring: Equatable {
        case alpha
        case beta(String?)
    }
}
