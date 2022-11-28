public protocol Graph {
    associatedtype Element

    func edges(from source: Element) -> [Edge<Element>]
    func weight(from source: Element, to destination: Element) -> Double?

    mutating func insert(_ element: Element, edges: [Edge<Element>])
    mutating func addDirectedEdge(from source: Element, to destination: Element, weight: Double?)
    mutating func addUndirectedEdge(from source: Element, to destination: Element, weight: Double?)
}

extension Graph {
    public mutating func addUndirectedEdge(from source: Element, to destination: Element, weight: Double?) {
        addDirectedEdge(from: source, to: destination, weight: weight)
        addDirectedEdge(from: destination, to: source, weight: weight)
    }
}

public struct Edge<Element> {
    public var source: Element
    public var destination: Element
    public var weight: Double?
}

public struct AdjacencyList<T: Hashable> {
    private var inner: [T: [Edge<T>]] = [:]

    public var nodes: [T] {
        Array(inner.keys)
    }

    public var count: Int {
        inner.sum(of: \.value.count)
    }

    public var isEmpty: Bool {
        inner.isEmpty
    }

    public init() {}
}

extension AdjacencyList: Graph {
    public func edges(from source: T) -> [Edge<T>] {
        inner[source] ?? []
    }

    public func weight(from source: T, to destination: T) -> Double? {
        edges(from: source)
            .first { $0.destination == destination }
            .flatMap { $0.weight }
    }

    public mutating func insert(_ element: T, edges: [Edge<T>] = []) {
        if contains(element) {
            return
        }

        inner[element] = edges
    }

    public mutating func addDirectedEdge(from source: T, to destination: T, weight: Double?) {
        insert(source)

        let edge = Edge(source: source,
                        destination: destination,
                        weight: weight)

        inner[source]!.append(edge)
    }
}

extension AdjacencyList: Sequence {
    public func makeIterator() -> Dictionary<T, Array<Edge<T>>>.Keys.Iterator {
        inner.keys.makeIterator()
    }
}

extension AdjacencyList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: (T, [Edge<T>])...) {
        self.init()
        for element in elements {
            insert(element.0, edges: element.1)
        }
    }
}
