import ScopedUnion

extension ScopedUnions {
    @ScopedUnion("LabeledType")
    enum Labeled: Equatable {
        case single(value: Int?)
        case multi(first: Int?, second: String?)
        case plain
    }
}
