import Lexic

extension ScopedUnionMacro {
    struct Configuration {
        let peerTypeName: String
        let project: [String]
    }
}
extension ScopedUnionMacro.Configuration: ExpressionListDecodable {
    enum CodingKey: String, Sendable {
        case peerTypeName = "_"
        case project
    }

    init(from list: inout ExpressionListDecoder<CodingKey>) throws {
        self.init(
            peerTypeName: try list[.peerTypeName]?.decode() ?? "Type",
            project: try list[.project]?.decode() ?? []
        )
    }
}
