@attached(
    peer,
    names: arbitrary
) @attached(
    member,
    names: named(type), arbitrary
) public macro ScopedUnion(
    _ peerTypeName: String,
    project: [String] = [],
    flatten: Bool = true
) = #externalMacro(
    module: "LexicMacros",
    type: "ScopedUnionMacro"
)
