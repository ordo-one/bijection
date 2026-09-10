import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("FlattenedType", project: ["tag"])
    enum Flattened: Equatable {
        case item(Int?)
        case other(String?)
        case plain

        @inline(always) static func tag(_ value: some CustomStringConvertible) -> String? {
            let description: String = value.description
            return description.isEmpty ? nil : description
        }
    }
}
