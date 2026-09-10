import Discriminated

extension DiscriminatedTests {
    @Discriminated(discriminant: "CustomTypeName") enum Custom: Equatable {
        case first
        case second(Int?)
    }
}
