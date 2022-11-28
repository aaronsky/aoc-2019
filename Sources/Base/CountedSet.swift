public struct CountedSet<Element: Hashable>: Sequence, ExpressibleByArrayLiteral {
    public typealias Iterator = Dictionary<Element, Int>.Iterator

    private var inner: [Element: Int] = [:]

    public init() {}

    public init<S: Sequence>(
        _ sequence: S
    ) where S.Element == Element {
        self.init()

        for element in sequence {
            insert(element)
        }
    }

    public init(
        arrayLiteral elements: Element...
    ) {
        self.init(elements)
    }

    public subscript(element: Element) -> Int {
        get {
            count(for: element)
        }
        set {
            inner[element] = newValue
        }
    }

    public mutating func insert(_ element: Element) {
        inner[element, default: 0] += 1
    }

    public func count(for element: Element) -> Int {
        inner[element] ?? 0
    }

    public mutating func remove(_ element: Element) {
        guard let count = inner[element] else {
            return
        }

        if count > 1 {
            inner[element] = count - 1
        } else {
            inner.removeValue(forKey: element)
        }
    }

    public func makeIterator() -> Iterator {
        inner.makeIterator()
    }
}
