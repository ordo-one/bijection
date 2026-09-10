@attached(
    peer,
    names: arbitrary
) @attached(
    member,
    names: named(type), arbitrary
) public macro ScopedUnion(
    _ peerTypeName: String,
    project: [String] = []
) = #externalMacro(
    module: "LexicMacros",
    type: "ScopedUnionMacro"
)
