import Discriminated

extension DiscriminatedUnions {
    @Discriminated(discriminant: "CustomTypeName") enum Custom: Equatable {
        case first
        case second(Int?)
    }
}
