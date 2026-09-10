import Testing

@Suite struct ProjectionTests {
    @Test static func SingleProjection() {
        #expect(Single.click(123).id == "123")
        #expect(Single.hover("area").id == "area")
        #expect(Single.click(nil).id == nil)
        #expect(Single.hover(nil).id == nil)
        #expect(Single.scroll.id == nil)
    }

    @Test static func MultipleProjections() {
        #expect(Multi.text("hello").owner == "hello")
        #expect(Multi.text("hello").count == 5)

        #expect(Multi.numbers([1, 2, 3]).owner == "[1, 2, 3]")
        #expect(Multi.numbers([1, 2, 3]).count == 3)

        #expect(Multi.text(nil).owner == nil)
        #expect(Multi.text(nil).count == nil)
        #expect(Multi.numbers(nil).owner == nil)
        #expect(Multi.numbers(nil).count == nil)
        #expect(Multi.none.owner == nil)
        #expect(Multi.none.count == nil)
    }

    @Test static func FlattenedOptional() {
        let tagItem: String? = Flattened.item(42).tag
        #expect(tagItem == "42")

        let tagOther: String? = Flattened.other("").tag
        #expect(tagOther == nil)

        #expect(Flattened.item(nil).tag == nil)
        #expect(Flattened.other(nil).tag == nil)
        #expect(Flattened.plain.tag == nil)
    }

    @Test static func UnflattenedOptional() {
        let tagItem: String?? = Unflattened.item(42).tag
        #expect(tagItem == .some(.some("42")))

        let tagOther: String?? = Unflattened.other("").tag
        #expect(tagOther == .some(nil))

        #expect(Unflattened.item(nil).tag == nil)
        #expect(Unflattened.other(nil).tag == nil)
        #expect(Unflattened.plain.tag == nil)
    }

    @Test static func UnsugaredOptional() {
        let tagItem: Optional<String>? = Unsugared.item(42).tag
        #expect(tagItem == .some(.some("42")))

        let tagOther: Optional<String>? = Unsugared.other("").tag
        #expect(tagOther == .some(nil))

        #expect(Unsugared.item(nil).tag == nil)
        #expect(Unsugared.other(nil).tag == nil)
        #expect(Unsugared.plain.tag == nil)
    }

    @Test static func RecursiveEnum() {
        let node: Recursive = .node(42)
        #expect(node.tag == "42")
    }
}
