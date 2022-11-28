import Algorithms
import Base

struct Day8: Day {
    var entries: [Entry]

    init(
        _ input: Input
    ) throws {
        entries = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        let totalUniqueNumbers = entries.sum { entry in
            entry.output.count(where: {
                $0.count == 2  // 1
                    || $0.count == 4  // 4
                    || $0.count == 3  // 7
                    || $0.count == 7  // 8
            })
        }

        return "\(totalUniqueNumbers)"
    }

    func partTwo() async -> String {
        let outputsSum = entries.sum {
            $0.decodeOutput()
        }

        return "\(outputsSum)"
    }

    struct Entry: RawRepresentable {
        static let patterns = [
            0b1110111,  // 0 -> abcefg
            0b0100100,  // 1 -> cf
            0b1011101,  // 2 -> acdeg
            0b1101101,  // 3 -> acdfg
            0b0101110,  // 4 -> bcdf
            0b1101011,  // 5 -> abdfg
            0b1111011,  // 6 -> abdefg
            0b0100101,  // 7 -> acf
            0b1111111,  // 8 -> abcdefg
            0b1101111,  // 9 -> abcdfg
        ]

        var digits: [[Int]]
        var output: [[Int]]

        var rawValue: String {
            """
            \(digits.map { $0.map(String.init).joined() }.joined(separator: " ")) | \(output.map { $0.map(String.init).joined() }.joined(separator: " "))
            """
        }

        init?(
            rawValue: String
        ) {
            func characterToNumber(c: Character) -> Int {
                switch c {
                case "a":
                    return 0
                case "b":
                    return 1
                case "c":
                    return 2
                case "d":
                    return 3
                case "e":
                    return 4
                case "f":
                    return 5
                case "g":
                    return 6
                default:
                    preconditionFailure()
                }
            }

            let components = rawValue.components(separatedBy: " | ").prefix(2)
            precondition(components.count == 2)

            digits = components[0]
                .components(separatedBy: " ")
                .map {
                    $0.map(characterToNumber)
                }

            output = components[1]
                .components(separatedBy: " ")
                .map {
                    $0.map(characterToNumber)
                }
        }

        func decodeOutput() -> Int {
            let permutations = Array((0..<7).permutations())
            let permutation = self.permutation(for: digits, permutations: permutations)

            return Int(
                digits: output.map {
                    let bitPattern =
                        $0
                        .map { permutation[$0] }
                        .reduce(0) { $0 | (1 << $1) }
                    let digit = Self.patterns.firstIndex(of: bitPattern)!

                    return digit
                }
            )
        }

        private func digitMatchesPermutation(_ pattern: [Int], _ permutation: [Int]) -> Bool {
            Self.patterns.contains(where: { candidate in
                candidate.nonzeroBitCount == pattern.count
                    && pattern.allSatisfy {
                        (candidate >> permutation[$0]) & 1 == 1
                    }
            })
        }

        private func permutation(for digits: [[Int]], permutations: [[Int]]) -> [Int] {
            permutations.first(where: { perm in
                digits.allSatisfy {
                    digitMatchesPermutation($0, perm)
                }
            })!
        }
    }
}
