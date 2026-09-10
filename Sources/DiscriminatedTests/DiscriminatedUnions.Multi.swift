import Discriminated

extension DiscriminatedUnions {
    @Discriminated(project: ["owner", "count"]) enum Multi: Equatable {
        case text(String?)
        case numbers([Int]?)
        case none

        @inline(always) static func owner(_ value: some CustomStringConvertible) -> String {
            value.description
        }
        @inline(always) static func count(_ value: some Collection) -> Int {
            value.count
        }
    }
}
