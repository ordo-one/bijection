import Discriminated

extension DiscriminatedTests {
    @Discriminated enum Action: Equatable {
        case start
        case stop
        case reset(Int?)
    }
}
