import ScopedUnion
import Testing

@Suite struct ScopedUnionMacroTests {
    @ScopedUnion("ActionType")
    enum Action: Equatable {
        case start
        case stop
        case reset(Int?)
    }

    @ScopedUnion("EventType", project: ["id"])
    enum Event: Equatable {
        case click(Int?)
        case hover(String?)
        case scroll

        @inline(always) static func id(_ value: some CustomStringConvertible) -> String {
            value.description
        }
    }

    @ScopedUnion("MultiType", project: ["owner", "count"])
    enum Multi: Equatable {
        case text(String?)
        case numbers(Array<Int>?)
        case none

        @inline(always) static func owner(_ value: some CustomStringConvertible) -> String {
            value.description
        }
        @inline(always) static func count(_ value: some Collection) -> Int {
            value.count
        }
    }

    @Test static func PureDiscriminator() {
        #expect(Action.start.type == .start)
        #expect(Action.stop.type == .stop)
        #expect(Action.reset.type == .reset)
        #expect(Action.reset(42).type == .reset)

        #expect(ActionType.start.rawValue == "start")
        #expect(ActionType.stop.rawValue == "stop")
        #expect(ActionType.reset.rawValue == "reset")
        #expect(ActionType.allCases == [.start, .stop, .reset])

        #expect(Action.reset == .reset(nil))
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

    @ScopedUnion("LabeledType")
    enum Labeled: Equatable {
        case single(value: Int?)
        case multi(first: Int?, second: String?)
        case plain
    }

    @Test static func LabeledAndMultiParameter() {
        #expect(Labeled.single.type == .single)
        #expect(Labeled.multi.type == .multi)
        #expect(Labeled.plain.type == .plain)

        #expect(Labeled.single == .single(value: nil))
        #expect(Labeled.multi == .multi(first: nil, second: nil))

        #expect(LabeledType.allCases == [.single, .multi, .plain])
    }
}
