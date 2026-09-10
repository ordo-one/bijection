import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("IntBackedType", backing: Int.self)
    enum IntBacked: Equatable {
        case low
        case medium
        case high(Double?)
    }
}
