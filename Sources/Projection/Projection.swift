@attached(
    member,
    names: arbitrary
) public macro Projection(
    through: String,
    flatten: Bool = true
) = #externalMacro(
    module: "LexicMacros",
    type: "ProjectionMacro"
)
