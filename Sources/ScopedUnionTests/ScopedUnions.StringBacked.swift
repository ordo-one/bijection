import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("StringBackedType", backing: String.self)
    enum StringBacked: Equatable {
        case first
        case second(Int?)
    }
}
