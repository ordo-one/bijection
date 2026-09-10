import Lexic
import SwiftSyntax

extension DiscriminatedMacro {
    struct Configuration {
        let discriminant: String?
        let backing: TypeSyntax?
    }
}
extension DiscriminatedMacro.Configuration: ExpressionListDecodable {
    enum CodingKey: String, Sendable {
        case discriminant
        case backing
    }

    init(from list: inout ExpressionListDecoder<CodingKey>) throws {
        self.init(
            discriminant: try list[.discriminant]?.decode(),
            backing: try list[.backing]?.decode(to: MetatypeExpression?.self)?.type
        )
    }
}
