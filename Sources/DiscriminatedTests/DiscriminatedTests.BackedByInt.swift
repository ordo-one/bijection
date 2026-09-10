import Discriminated

extension DiscriminatedTests {
    @Discriminated(backing: Int.self) enum BackedByInt: Equatable {
        case low
        case medium
        case high(Double?)
    }
}
