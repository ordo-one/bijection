import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("SubstringBackedType", backing: Substring.self)
    enum SubstringBacked: Equatable {
        case alpha
        case beta(String?)
    }
}
