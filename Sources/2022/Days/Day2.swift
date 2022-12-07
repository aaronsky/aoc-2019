import Algorithms
import Base

struct Day2: Day {
    /// A and X are Rock, Rock is worth 1
    /// B and Y are Paper, Paper is worth 2
    /// C and Z are Scissors, Scissors are worth 3
    private let versusOutcomes: [String: [String: Int]] = [
        "A": ["X": 4, "Y": 8, "Z": 3],
        "B": ["X": 1, "Y": 5, "Z": 9],
        "C": ["X": 7, "Y": 2, "Z": 6],
    ]

    /// X is Lose
    /// Y is Tie
    /// Z is Win
    private let predictiveOutcomes: [String: [String: Int]] = [
        "A": ["X": 3, "Y": 4, "Z": 8],
        "B": ["X": 1, "Y": 5, "Z": 9],
        "C": ["X": 2, "Y": 6, "Z": 7],
    ]

    var moves: [(String, String)]

    init(
        _ input: Input
    ) throws {
        moves = input.lines.compactMap {
            let moves = $0.components(separatedBy: " ")
            guard moves.count == 2 else { return nil }
            return (moves[0], moves[1])
        }
    }

    func partOne() async -> String {
        "\(moves.sum(of: { versusOutcomes[$0.0]![$0.1]! }))"
    }

    func partTwo() async -> String {
        "\(moves.sum(of: { predictiveOutcomes[$0.0]![$0.1]! }))"
    }
}
