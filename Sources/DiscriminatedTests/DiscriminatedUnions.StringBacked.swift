import Discriminated

extension DiscriminatedUnions {
    @Discriminated(backing: String.self)
    enum StringBacked: Equatable {
        case first
        case second(Int?)
    }
}
