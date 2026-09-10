@attached(
    peer,
    names: arbitrary
) @attached(
    member,
    names: named(type), arbitrary
) public macro ScopedUnion(
    _ peerTypeName: String,
    backing: Any.Type? = nil,
    project: [String] = [],
    flatten: Bool = true
) = #externalMacro(
    module: "LexicMacros",
    type: "ScopedUnionMacro"
)
