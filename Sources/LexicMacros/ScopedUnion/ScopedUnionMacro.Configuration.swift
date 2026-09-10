import Lexic
import SwiftSyntax

extension ScopedUnionMacro {
    struct Configuration {
        let peerTypeName: String
        let backing: TypeSyntax?
        let project: [String]
        let flatten: Bool
    }
}
extension ScopedUnionMacro.Configuration: ExpressionListDecodable {
    enum CodingKey: String, Sendable {
        case peerTypeName = "_"
        case backing
        case project
        case flatten
    }

    init(from list: inout ExpressionListDecoder<CodingKey>) throws {
        self.init(
            peerTypeName: try list[.peerTypeName]?.decode() ?? "Type",
            backing: try list[.backing]?.decode(to: MetatypeExpression?.self)?.type,
            project: try list[.project]?.decode() ?? [],
            flatten: try list[.flatten]?.decode() ?? true
        )
    }
}
