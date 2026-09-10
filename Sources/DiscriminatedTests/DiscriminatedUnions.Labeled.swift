import Discriminated

extension DiscriminatedUnions {
    @Discriminated enum Labeled: Equatable {
        case single(value: Int?)
        case multi(first: Int?, second: String?)
        case plain
    }
}
