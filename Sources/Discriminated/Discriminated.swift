@attached(
    peer,
    names: arbitrary
) @attached(
    member,
    names: named(type)
) public macro Discriminated(
    discriminant: String? = nil,
    backing: Any.Type? = nil
) = #externalMacro(
    module: "LexicMacros",
    type: "DiscriminatedMacro"
)
