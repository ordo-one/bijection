import Discriminated

extension DiscriminatedUnions {
    @Discriminated(project: ["tag"], flatten: false)
    enum Unflattened: Equatable {
        case item(Int?)
        case other(String?)
        case plain

        @inline(always) static func tag(_ value: some CustomStringConvertible) -> String? {
            let description: String = value.description
            return description.isEmpty ? nil : description
        }
    }
}
