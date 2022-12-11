import Algorithms
import Base
import RegexBuilder

struct Day10: Day {
    enum Instruction {
        case addx(Int)
        case noop

        init?(rawValue: String) {
            if let match = rawValue.firstMatch(of: Regex {
                "addx "
                TryCapture {
                    Optionally("-")
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }
            }) {
                self = .addx(match.1)
            } else if rawValue == "noop" {
                self = .noop
            } else {
                return nil
            }
        }
    }

    var instructions: [Instruction]

    init(_ input: Input) throws {
        instructions = input.decodeMany(separatedBy: "\n", transform: Instruction.init(rawValue:))
    }

    func partOne() async -> String {
        let specifics: Set<Int> = [20, 60, 100, 140, 180, 220]
        var total = 0

        run(startingFromCycle: 1) { cycle, x in
            guard specifics.contains(cycle) else { return }
            total += cycle * x
        }

        return "\(total)"
    }

    func partTwo() async -> String {
        var grid = Array(repeating: Array(repeating: false, count: 40), count: 6)

        run { cycle, x in
            let (row, col) = cycle.quotientAndRemainder(dividingBy: 40)
            guard grid.indices.contains(row) && grid[row].indices.contains(col) else { return }

            grid[row][col] = ((x - 1)...(x + 1)).contains(row)
        }

        print(
            grid.map {
                $0.map {
                    $0 ? "#" : " "
                }.joined()
            }.joined(separator: "\n")
        )

        return "EPJBRKAH"
    }

    func run(startingFromCycle cycle: Int = 0, onTick: (_ cycle: Int, _ x: Int) -> Void) {
        var x = 1
        var cycle = cycle

        for instruction in instructions {
            onTick(cycle, x)

            switch instruction {
            case .addx(let incr):
                cycle += 1
                onTick(cycle, x)
                cycle += 1
                x += incr
            case .noop:
                cycle += 1
            }
        }
    }
}
