import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: Int.self)
    enum BackedByInt: Equatable {
        case low
        case medium
        case high(Double?)
    }
}
