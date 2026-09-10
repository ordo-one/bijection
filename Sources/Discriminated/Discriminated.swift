@attached(
    peer,
    names: arbitrary
) @attached(
    member,
    names: named(type), arbitrary
) public macro Discriminated(
    discriminant: String? = nil,
    backing: Any.Type? = nil,
    project: [String] = [],
    flatten: Bool = true
) = #externalMacro(
    module: "LexicMacros",
    type: "DiscriminatedMacro"
)
