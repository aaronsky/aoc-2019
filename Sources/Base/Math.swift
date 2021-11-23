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

extension Double {
    public static let tau = .pi * 2.0
}
