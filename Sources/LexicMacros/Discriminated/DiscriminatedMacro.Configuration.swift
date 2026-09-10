import Lexic
import SwiftSyntax

extension DiscriminatedMacro {
    struct Configuration {
        let discriminant: String?
        let backing: TypeSyntax?
        let project: [String]
        let flatten: Bool
    }
}
extension DiscriminatedMacro.Configuration: ExpressionListDecodable {
    enum CodingKey: String, Sendable {
        case discriminant
        case backing
        case project
        case flatten
    }

    init(from list: inout ExpressionListDecoder<CodingKey>) throws {
        self.init(
            discriminant: try list[.discriminant]?.decode(),
            backing: try list[.backing]?.decode(to: MetatypeExpression?.self)?.type,
            project: try list[.project]?.decode() ?? [],
            flatten: try list[.flatten]?.decode() ?? true
        )
    }
}
