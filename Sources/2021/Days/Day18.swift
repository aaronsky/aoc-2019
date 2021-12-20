//
//  Day18.swift
//
//
//  Created by Aaron Sky on 12/18/21.
//

import Algorithms
import Base

struct Day18: Day {
    var fish: [Snailfish]

    init(_ input: Input) throws {
        fish = input.decodeMany(separatedBy: "\n")
    }
    
    func partOne() async -> String {
        guard let result = fish.reduce(+) else {
            return ""
        }
        
        return "\(result.magnitude)"
    }
    
    func partTwo() async -> String {
        let result = fish
            .permutations(ofCount: 2)
            .map {
                ($0[0] + $0[1]).magnitude
            }
            .max()!

        return "\(result)"
    }

    struct Snailfish: RawRepresentable {
        enum Element {
            case open
            case close
            case value(Int)

            var value: Int? {
                guard case .value(let number) = self else {
                    return nil
                }

                return number
            }

            init?(_ c: Character) {
                switch c {
                case "[":
                    self = .open
                case "]":
                    self = .close
                default:
                    guard let number = Int(String(c)) else {
                        return nil
                    }
                    self = .value(number)
                }
            }
        }

        var elements: [Element]

        var magnitude: Int {
            func rec(_ index: inout Int) -> Int {
                if let value = elements[index].value {
                    index += 1
                    return value
                } else {
                    index += 1 // .open
                    let left = rec(&index)
                    let right = rec(&index)
                    index += 1 // .close
                    return 3 * left + 2 * right
                }
            }

            var index = 0
            return rec(&index)
        }

        var rawValue: String {
            ""
        }

        init(elements: [Element]) {
            self.elements = elements
        }

        init?(rawValue: String) {
            self.init(elements: rawValue.compactMap(Element.init))
        }

        mutating func reduce() {
            while reduceExplode() || reduceSplit() {}
        }

        /// Returns `true` if the reduction was successful.
        mutating func reduceExplode() -> Bool {
            var level = 0

            for (index, element) in elements.enumerated() {
                switch element {
                case .open:
                    level += 1
                case .close:
                    level -= 1
                case .value:
                    break
                }

                if level == 5 {
                    if let prev = elements[..<index].lastIndex(where: { $0.value != nil }) {
                        elements[prev] = .value(elements[prev].value! + elements[index + 1].value!)
                    }
                    if let next = elements[(index + 4)...].firstIndex(where: { $0.value != nil }) {
                        elements[next] = .value(elements[next].value! + elements[index + 2].value!)
                    }

                    elements.replaceSubrange(index..<(index + 4), with: [.value(0)])
                    return true
                }
            }

            return false
        }

        /// Returns `true` if the reduction was successful.
        mutating func reduceSplit() -> Bool {
            for (index, element) in elements.enumerated() {
                guard let value = element.value, value >= 10 else {
                    continue
                }
                elements.replaceSubrange(
                    index..<(index + 1),
                    with: [.open, .value(value / 2), .value((value + 1) / 2), .close])

                return true
            }

            return false
        }

        static func + (lhs: Self, rhs: Self) -> Self {
            var new = Self(elements: [.open] + lhs.elements + rhs.elements + [.close])
            new.reduce()
            return new
        }

    }
}
