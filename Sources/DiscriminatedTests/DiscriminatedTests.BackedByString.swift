import Discriminated

extension DiscriminatedTests {
    @Discriminated(backing: String.self) enum BackedByString: Equatable {
        case first
        case second(Int?)
    }
}
