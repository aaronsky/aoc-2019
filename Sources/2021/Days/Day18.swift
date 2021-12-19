//
//  Day18.swift
//
//
//  Created by Aaron Sky on 12/18/21.
//

import Algorithms
import Base

struct Day18: Day {
    var snailfish: [Snailfish]

    init(_ input: Input) throws {
        // snailfish = input.decodeMany(separatedBy: "\n")
        snailfish = []
    }

    func partOne() async -> String {
        guard let first = snailfish.first else {
            return ""
        }

        let result = snailfish
            .dropFirst()
            .reduce(into: first) { acc, next in
            acc += next
        }

        return "\(result.magnitude)"
    }

    func partTwo() async -> String {
        ""
    }

    enum Snailfish: CustomStringConvertible, RawRepresentable {
        case number(Int)
        indirect case pair(Snailfish, Snailfish)

        var magnitude: Int {
            switch self {
            case .number(let number):
                return number
            case .pair(let one, let two):
                return 3 * one.magnitude + 2 * two.magnitude
            }
        }

        var description: String {
            rawValue
        }

        var rawValue: String {
            switch self {
            case .number(let number):
                return "\(number)"
            case .pair(let one, let two):
                return "[\(one.rawValue), \(two.rawValue)]"
            }
        }

        init?(rawValue: String) {
            guard !rawValue.isEmpty else {
                return nil
            }

            var rawValue = rawValue
            self.init(rawValue: &rawValue)
        }

        private init?(rawValue: inout String) {
            let c = rawValue.removeFirst()
            switch c {
            case "[":
                guard let one = Self(rawValue: &rawValue),
                      rawValue.removeFirst() == ",",
                      let two = Self(rawValue: &rawValue),
                      rawValue.removeFirst() == "]" else {
                          return nil
                      }
                self = .pair(one, two)
            default:
                guard let number = Int(String(c)) else {
                    return nil
                }
                self = .number(number)
            }
        }

        static func +(_ lhs: Self, _ rhs: Self) -> Self {
            var added: Snailfish = .pair(lhs, rhs)
            added.reduce()
            return added
        }

        static func +=(_ lhs: inout Self, _ rhs: Self) {
            lhs = lhs + rhs
        }

        @discardableResult
        mutating func reduce(depth: Int = 1) -> Bool {
            switch self {
            case .number(let int):
                return false
            case .pair(let one, let two) where depth >= 4:

                self = .number(0)
                return true
            case .pair(var one, var two):
                return one.reduce(depth: depth + 1) || two.reduce(depth: depth + 1)
            }
        }
    }
}
