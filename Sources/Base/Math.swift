import Foundation

extension BinaryInteger {
    public var digits: Digits<Self> {
        Digits(self)
    }

    public var countDigits: Int {
        String(describing: self).count
    }

    public var triangularSum: Self {
        (self * (self + 1)) / 2
    }

    public var bits: [Bool] {
        (0..<bitWidth)
            .reduce(into: []) { acc, offset in
                acc.append((self & (1 << offset)) > 0)
            }
            .reversed()
    }
}

extension SignedInteger where Self: FixedWidthInteger {
    public func leastCommonMultiple(_ other: Self) -> Self {
        if self == 0 && other == 0 {
            return 0
        }
        return self * (other / greatestCommonMultiple(other))
    }

    public func greatestCommonMultiple(_ other: Self) -> Self {
        // Use Stein's algorithm
        var m = self
        var n = other

        if m == 0 || n == 0 {
            return abs(m | n)
        }

        let shift = (m | n).trailingZeroBitCount
        if m == Self.min || n == Self.max {
            return abs(1 << shift)
        }

        m = abs(m)
        n = abs(n)

        m >>= m.trailingZeroBitCount
        n >>= n.trailingZeroBitCount

        while m != n {
            if m > n {
                m -= n
                m >>= m.trailingZeroBitCount
            } else {
                n -= m
                n >>= n.trailingZeroBitCount
            }
        }

        return m << shift
    }
}

public struct Digits<I: BinaryInteger>: Sequence {
    var value: I

    init(_ value: I) {
        self.value = value
    }

    public func makeIterator() -> Array<I>.Iterator {
        sequence(first: value) {
            let p = $0 / 10
            guard p != 0 else {
                return nil
            }
            return p
        }
        .reversed()
        .map { $0 % 10 }
        .makeIterator()
    }
}

extension Int {
    public init<S: Sequence>(bits: S) where S.Element == Bool {
        self = bits.reduce(0, { $0 * 2 + ($1 ? 1 : 0) })
    }

    public init<S: Sequence>(digits: S) where S.Element == Self {
        self = digits.reduce(0, { $0 * 10 + $1 })
    }
}

extension Double {
    public static let tau = .pi * 2.0
}
