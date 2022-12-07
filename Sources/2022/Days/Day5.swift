import Algorithms
import Base
import RegexBuilder

struct Day5: Day {
    enum ParsingError: Error {
        case malformedInput
        case noMatch
    }

    struct Instruction {
        var count: Int
        var from: Int
        var to: Int

        init(
            from contents: String
        ) throws {
            let countRef = Reference<Int>()
            let fromRef = Reference<Int>()
            let toRef = Reference<Int>()
            let pattern = Regex {
                "move "
                TryCapture(OneOrMore(.digit), as: countRef, transform: { Int($0) })
                " from "
                TryCapture(OneOrMore(.digit), as: fromRef, transform: { Int($0) })
                " to "
                TryCapture(OneOrMore(.digit), as: toRef, transform: { Int($0) })
            }

            guard let match = try pattern.firstMatch(in: contents) else { throw ParsingError.noMatch }
            self.init(count: match[countRef], from: match[fromRef], to: match[toRef])
        }

        init(
            count: Int,
            from: Int,
            to: Int
        ) {
            self.count = count
            self.from = from
            self.to = to
        }
    }

    var crates: [[String]] = [
        [""],
        ["B", "S", "V", "Z", "G", "P", "W"],
        ["J", "V", "B", "C", "Z", "F"],
        ["V", "L", "M", "H", "N", "Z", "D", "C"],
        ["L", "D", "M", "Z", "P", "F", "J", "B"],
        ["V", "F", "C", "G", "J", "B", "Q", "H"],
        ["G", "F", "Q", "T", "S", "L", "B"],
        ["L", "G", "C", "Z", "V"],
        ["N", "L", "G"],
        ["J", "F", "H", "C"],
    ]
    var instructions: [Instruction]

    init(
        _ input: Input
    ) throws {
        let pieces = input.lines.split(on: \.isEmpty)
        guard pieces.count == 2 else { throw ParsingError.malformedInput }
        let (_, rawInstructions) = (pieces[0], pieces[1])
        instructions = try rawInstructions.compactMap(Instruction.init(from:))
    }

    func partOne() async -> String {
        var crates = crates
        for instruction in instructions {
            for _ in 0..<instruction.count {
                let crate = crates[instruction.from].popLast()!
                crates[instruction.to].append(crate)
            }
        }
        return crates.map { $0.last! }.joined()
    }

    func partTwo() async -> String {
        var crates = crates
        for instruction in instructions {
            var poppedCrates: [String] = []
            for _ in 0..<instruction.count {
                let crate = crates[instruction.from].popLast()!
                poppedCrates.insert(crate, at: poppedCrates.startIndex)
            }
            crates[instruction.to].append(contentsOf: poppedCrates)
        }
        return crates.map { $0.last! }.joined()
    }
}
