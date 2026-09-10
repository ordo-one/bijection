import Testing

@Suite struct DiscriminatedUnions {
    @Test static func PureDiscriminator() {
        #expect(Action.start.type == .start)
        #expect(Action.stop.type == .stop)
        #expect(Action.reset.type == .reset)
        #expect(Action.reset(89).type == .reset)

        #expect(ActionType.allCases == [.start, .stop, .reset])

        #expect(Action.reset == .reset(nil))
    }

    @Test static func ExplicitDiscriminant() {
        #expect(Custom.first.type == .first)
        #expect(Custom.second(10).type == .second)
        #expect(CustomTypeName.allCases == [.first, .second])
    }

    @Test static func SingleProjection() {
        #expect(Event.click(123).id == "123")
        #expect(Event.hover("area").id == "area")
        #expect(Event.click.id == nil)
        #expect(Event.hover.id == nil)
        #expect(Event.scroll.id == nil)

        #expect(Event.click(123).type == .click)
        #expect(Event.scroll.type == .scroll)
        #expect(EventType.allCases == [.click, .hover, .scroll])
    }

    @Test static func MultipleProjections() {
        #expect(Multi.text("hello").owner == "hello")
        #expect(Multi.text("hello").count == 5)

        #expect(Multi.numbers([1, 2, 3]).owner == "[1, 2, 3]")
        #expect(Multi.numbers([1, 2, 3]).count == 3)

        #expect(Multi.text.owner == nil)
        #expect(Multi.text.count == nil)
        #expect(Multi.numbers.owner == nil)
        #expect(Multi.numbers.count == nil)
        #expect(Multi.none.owner == nil)
        #expect(Multi.none.count == nil)
    }

    @Test static func LabeledAndMultiParameter() {
        #expect(Labeled.single.type == .single)
        #expect(Labeled.multi.type == .multi)
        #expect(Labeled.plain.type == .plain)

        #expect(Labeled.single == .single(value: nil))
        #expect(Labeled.multi == .multi(first: nil, second: nil))

        #expect(LabeledType.allCases == [.single, .multi, .plain])
    }

    @Test static func FlattenedOptional() {
        let tagItem: String? = Flattened.item(89).tag
        #expect(tagItem == "89")

        let tagOther: String? = Flattened.other("").tag
        #expect(tagOther == nil)

        #expect(Flattened.item.tag == nil)
        #expect(Flattened.other.tag == nil)
        #expect(Flattened.plain.tag == nil)
    }

    @Test static func UnflattenedOptional() {
        let item: String?? = Unflattened.item(89).tag
        #expect(item == .some(.some("89")))

        let other: String?? = Unflattened.other("").tag
        #expect(other == .some(nil))

        #expect(Unflattened.item.tag == nil)
        #expect(Unflattened.other.tag == nil)
        #expect(Unflattened.plain.tag == nil)
    }

    @Test static func UnsugaredOptional() {
        let item: Optional<String>? = Unsugared.item(89).tag
        #expect(item == .some(.some("89")))

        let other: Optional<String>? = Unsugared.other("").tag
        #expect(other == .some(nil))

        #expect(Unsugared.item.tag == nil)
        #expect(Unsugared.other.tag == nil)
        #expect(Unsugared.plain.tag == nil)
    }

    @Test static func BackingTypes() {
        #expect(BackedByStringType.first.rawValue == "first")
        #expect(BackedByStringType.second.rawValue == "second")
        #expect(BackedByStringType.allCases == [.first, .second])

        let alpha: Substring = BackedBySubstringType.alpha.rawValue
        #expect(alpha == "alpha")
        let beta: Substring = BackedBySubstringType.beta.rawValue
        #expect(beta == "beta")

        #expect(BackedByIntType.low.rawValue == 0)
        #expect(BackedByIntType.medium.rawValue == 1)
        #expect(BackedByIntType.high.rawValue == 2)
    }
}
