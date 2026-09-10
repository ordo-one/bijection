import Discriminated

extension DiscriminatedTests {
    @Discriminated indirect enum Recursive: Equatable {
        case leaf
        case node(Recursive?)
    }
}
