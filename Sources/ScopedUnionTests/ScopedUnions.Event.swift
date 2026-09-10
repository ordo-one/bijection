import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("EventType", project: ["id"])
    enum Event: Equatable {
        case click(Int?)
        case hover(String?)
        case scroll

        @inline(always) static func id(_ value: some CustomStringConvertible) -> String {
            value.description
        }
    }
}
