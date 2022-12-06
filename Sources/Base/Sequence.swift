import Foundation

extension Sequence where Element: Numeric {
    @inlinable
    public var sum: Element {
        reduce(0, +)
    }

    @inlinable
    public var product: Element {
        reduce(1, *)
    }
}

extension Sequence where Element == String {
    @inlinable
    public var integers: [Int] {
        compactMap(Int.init)
    }

    @inlinable
    public var characters: [[String.Element]] {
        map(Array.init)
    }
}

extension Sequence {
    @inlinable
    public func sum(of transform: (Element) throws -> Int) rethrows -> Int {
        var sum = 0
        for e in self {
            sum += try transform(e)
        }
        return sum
    }

    @inlinable
    public func product(of transform: (Element) throws -> Int) rethrows -> Int {
        var product = 1
        for e in self {
            product *= try transform(e)
        }
        return product
    }

    /// Returns the number of elements in the sequence that satisfy the given
    /// predicate.
    ///
    /// You can use this method to count the number of elements that pass a test.
    /// The following example finds the number of names that are fewer than
    /// five characters long:
    ///
    ///     let names = ["Jacqueline", "Ian", "Amy", "Juan", "Soroush", "Tiffany"]
    ///     let shortNameCount = names.count(where: { $0.count < 5 })
    ///     // shortNameCount == 3
    ///
    /// To find the number of times a specific element appears in the sequence,
    /// use the equal to operator (`==`) in the closure to test for a match.
    ///
    ///     let birds = ["duck", "duck", "duck", "duck", "goose"]
    ///     let duckCount = birds.count(where: { $0 == "duck" })
    ///     // duckCount == 4
    ///
    /// The sequence must be finite.
    ///
    /// - Parameter predicate: A closure that takes each element of the sequence
    ///   as its argument and returns a Boolean value indicating whether
    ///   the element should be included in the count.
    /// - Returns: The number of elements in the sequence that satisfy the given
    ///   predicate.
    @inlinable
    public func count(where predicate: (Element) throws -> Bool) rethrows -> Int {
        var count = 0
        for e in self where try predicate(e) {
            count += 1
        }
        return count
    }

    @inlinable
    public func print() -> Self {
        Swift.print(self)
        return self
    }

    @inlinable
    public func zip<OtherSequence: Sequence>(_ other: OtherSequence) -> Zip2Sequence<Self, OtherSequence> {
        Swift.zip(self, other)
    }
}

extension Sequence where Element: Equatable {
    @inlinable
    public func count(of element: Element) -> Int {
        count(where: { $0 == element })
    }
}

extension Collection where Element: BinaryInteger {
    @inlinable
    public var average: Double {
        guard !isEmpty else {
            return .nan
        }

        return Double(sum) / Double(count)
    }
}

extension Collection where Element: Hashable {
    @inlinable
    public var allUnique: Bool {
        var seen = Set<Element>()
        for item in self {
            if seen.contains(item) { return false }
            seen.insert(item)
        }
        return true
    }
}

public enum RoundingMedian {
    case high
    case low
}

extension Collection {
    public func median(rounding: RoundingMedian = .low) -> Element {
        let span = Double(distance(from: startIndex, to: endIndex))
        let halfSpan = span / 2

        let medianDistance: Int
        switch rounding {
        case .high:
            medianDistance = Int(ceil(halfSpan))
        case .low:
            medianDistance = Int(floor(halfSpan))
        }

        return self[index(startIndex, offsetBy: medianDistance)]
    }

    @inlinable
    public func reduce(_ nextPartialResult: (Element, Element) throws -> Element) rethrows -> Element? {
        guard let first = first else {
            return nil
        }

        return try dropFirst().reduce(first, nextPartialResult)
    }

    @inlinable
    public func reduce(_ updateAccumulatingResult: (inout Element, Element) throws -> Void) rethrows -> Element? {
        guard let first = first else {
            return nil
        }

        return try dropFirst().reduce(into: first, updateAccumulatingResult)
    }

    @inlinable
    public func split(on isBoundary: (Element) -> Bool, includeEmpty: Bool = true) -> [SubSequence] {
        return split(omittingEmptySubsequences: !includeEmpty, whereSeparator: isBoundary)
    }

    @inlinable
    public func split(at index: Index) -> (left: SubSequence, right: SubSequence) {
        let left = self[startIndex..<index]
        let right = self[index..<endIndex]
        return (left, right)
    }

    @inlinable
    public var middleIndex: Index {
        index(startIndex, offsetBy: count / 2)
    }
}

extension ArraySlice {
    @inlinable
    public mutating func popFirst() -> Element {
        removeFirst()
    }

    @inlinable
    public mutating func popFirst(_ k: Int) -> [Element] {
        (0..<k).map { _ in popFirst() }
    }
}

extension SetAlgebra {
    @inlinable
    @discardableResult
    public mutating func insert<S: Sequence>(
        contentsOf newElements: S
    ) -> [(inserted: Bool, memberAfterInsert: Self.Element)] where S.Element == Element {
        newElements.map {
            insert($0)
        }
    }
}

extension Sequence where Element: Sequence, Element.Element: Hashable {
    @inlinable
    public var intersection: Set<Element.Element> {
        var iter = makeIterator()
        guard let first = iter.next() else { return [] }
        var intersection = Set(first)
        while let next = iter.next() {
            intersection.formIntersection(Set(next))
            if intersection.isEmpty { break }
        }
        return intersection
    }
}
