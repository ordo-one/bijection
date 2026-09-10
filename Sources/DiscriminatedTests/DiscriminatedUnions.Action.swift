import Discriminated

extension DiscriminatedUnions {
    @Discriminated enum Action: Equatable {
        case start
        case stop
        case reset(Int?)
    }
}
