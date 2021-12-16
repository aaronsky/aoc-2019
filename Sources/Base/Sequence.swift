//
//  Sequence.swift
//  
//
//  Created by Aaron Sky on 12/1/21.
//

import Foundation

extension Sequence where Element: Numeric {
    public var sum: Element {
        reduce(0, +)
    }

    public var product: Element {
        reduce(1, *)
    }
}

extension Sequence {
    public func sum(of transform: (Element) throws -> Int) rethrows -> Int {
        var sum = 0
        for e in self {
            sum += try transform(e)
        }
        return sum
    }

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
        for e in self {
            if try predicate(e) {
                count += 1
            }
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

extension Collection where Element: BinaryInteger {
    var average: Double {
        guard !isEmpty else {
            return .nan
        }

        return Double(sum) / Double(count)
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
}

extension ArraySlice {
    public mutating func popFirst() -> Element {
        removeFirst()
    }

    public mutating func popFirst(_ k: Int) -> [Element] {
        (0..<k).map { _ in popFirst() }
    }
}
