//
//  Day14.swift
//
//
//  Created by Aaron Sky on 12/14/21.
//

import Algorithms
import Base

struct Day14: Day {
    var formula: PolymerFormula

    init(_ input: Input) throws {
        formula = input.decode()!
    }

    func partOne() async -> String {
        let difference = formula.polymerize(count: 10)
        return "\(difference)"
    }

    func partTwo() async -> String {
        let difference = formula.polymerize(count: 40)
        return "\(difference)"
    }

    struct PolymerFormula: RawRepresentable {
        var polymer: String
        var formulae: [String: Character]

        var rawValue: String {
            """
            \(polymer)

            \(formulae.map { "\($0.key) -> \($0.value)" }.joined(separator: "\n"))
            """
        }

        init?(rawValue: String) {
            let components = rawValue.components(separatedBy: "\n\n").prefix(2)
            guard components.count == 2 else {
                return nil
            }
            polymer = components[0]

            let formulaPairs: [(String, Character)] = components[1]
                .components(separatedBy: "\n")
                .compactMap { line in
                    let pair = line.components(separatedBy: " -> ").prefix(2)
                    guard pair.count == 2, pair[0].count == 2, pair[1].count == 1 else {
                        return nil
                    }
                    return (pair[0], Character(pair[1]))
            }
            formulae = Dictionary(uniqueKeysWithValues: formulaPairs)
        }

        func polymerize(count: Int = 1) -> Int {
            guard count >= 1 else {
                return 0
            }

            var counts = CountedSet(polymer.windows(ofCount: 2).map(String.init))

            for _ in 1...count {
                step(counts: &counts)
            }

            var final: CountedSet<Character> = []
            for (pair, count) in counts {
                for c in pair {
                    final[c] += count
                }
            }

            final[polymer.first!] += 1
            final[polymer.last!] += 1

            guard let (min, max) = final.minAndMax(by: { $0.value < $1.value }) else {
                return 0
            }

            let maxCount = max.value / 2
            let minCount = min.value / 2

            return maxCount - minCount
        }

        func step(counts: inout CountedSet<String>) {
            var newCounts: CountedSet<String> = []

            for (pair, count) in counts {
                guard let reaction = formulae[pair] else {
                    continue
                }

                let p1 = "\(pair.first!)\(reaction)"
                let p2 = "\(reaction)\(pair.last!)"
                newCounts[p1] += count
                newCounts[p2] += count
            }

            counts = newCounts
        }
    }
}
