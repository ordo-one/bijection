import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: String.self) enum BackedByString: Equatable {
        case first
        case second(Int?)
    }
}
