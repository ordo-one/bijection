import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("ActionType")
    enum Action: Equatable {
        case start
        case stop
        case reset(Int?)
    }
}
