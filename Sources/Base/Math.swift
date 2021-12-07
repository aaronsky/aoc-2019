//
//  Math.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

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
}

extension Double {
    public static let tau = .pi * 2.0
}
