import Lexic

extension ScopedUnionMacro {
    struct Configuration {
        let peerTypeName: String
        let project: [String]
        let flatten: Bool
    }
}
extension ScopedUnionMacro.Configuration: ExpressionListDecodable {
    enum CodingKey: String, Sendable {
        case peerTypeName = "_"
        case project
        case flatten
    }

    init(from list: inout ExpressionListDecoder<CodingKey>) throws {
        self.init(
            peerTypeName: try list[.peerTypeName]?.decode() ?? "Type",
            project: try list[.project]?.decode() ?? [],
            flatten: try list[.flatten]?.decode() ?? true
        )
    }
}
