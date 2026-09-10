import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: Int.self)
    enum IntBacked: Equatable {
        case low
        case medium
        case high(Double?)
    }
}
