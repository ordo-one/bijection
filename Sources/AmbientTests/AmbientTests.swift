import Testing

@Suite struct AmbientTests {
    @Test static func SingleParameter() {
        #expect(Simple.reset == .reset(nil))
    }

    @Test static func LabeledAndMultiParameter() {
        #expect(Labeled.single == .single(value: nil))
        #expect(Labeled.multi == .multi(first: nil, second: nil))
    }

    @Test static func RecursiveEnum() {
        let node: Recursive = .node
        #expect(node == .node(nil))
    }
}
