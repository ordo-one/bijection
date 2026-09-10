@attached(
    member,
    names: arbitrary
) public macro ambient() = #externalMacro(
    module: "LexicMacros",
    type: "AmbientMacro"
)
