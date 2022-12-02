import Algorithms
import Base

struct Day2: Day {
    let games: [(Move, Play)]

    init(_ input: Input) throws {
        games = input.lines.compactMap {
            let moves = $0.components(separatedBy: " ")
            guard moves.count == 2 else { return nil }
            return (Move(moves[0]), Play(moves[1]))
        }
    }

    func partOne() async -> String {
        let score = games.sum(of: { moves in
            let outcome: Outcome
            switch (moves.0, moves.1) {
            case (.a, .x):
                outcome = .draw
            case (.a, .y):
                outcome = .win
            case (.a, .z):
                outcome = .lose
            case (.b, .x):
                outcome = .lose
            case (.b, .y):
                outcome = .draw
            case (.b, .z):
                outcome = .win
            case (.c, .x):
                outcome = .win
            case (.c, .y):
                outcome = .lose
            case (.c, .z):
                outcome = .draw
            }

            return moves.1.rawValue + outcome.rawValue
        })

        return "\(score)"
    }

    func partTwo() async -> String {
        let score = games.sum(of: { moves in
            let outcome: Outcome
            let necessaryMove: Move

            switch moves.1 {
            case .x:
                outcome = .lose
            case .y:
                outcome = .draw
            case .z:
                outcome = .win
            }

            switch (moves.0, outcome) {
            case (.a, .lose):
                necessaryMove = .c
            case (.a, .draw):
                necessaryMove = .a
            case (.a, .win):
                necessaryMove = .b
            case (.b, .lose):
                necessaryMove = .a
            case (.b, .draw):
                necessaryMove = .b
            case (.b, .win):
                necessaryMove = .c
            case (.c, .lose):
                necessaryMove = .b
            case (.c, .draw):
                necessaryMove = .c
            case (.c, .win):
                necessaryMove = .a
            }

            return necessaryMove.rawValue + outcome.rawValue
        })

        return "\(score)"
    }

    enum Outcome: Int {
        case lose = 0, draw = 3, win = 6
    }

    enum Move: Int {
        case a = 1, b, c

        init(_ rawValue: String) {
            switch rawValue {
            case "A", "X":
                self = .a
            case "B", "Y":
                self = .b
            case "C", "Z":
                self = .c
            default:
                fatalError()
            }
        }
    }

    enum Play: Int {
        case x = 1, y, z

        init(_ rawValue: String) {
            switch rawValue {
            case "X":
                self = .x
            case "Y":
                self = .y
            case "Z":
                self = .z
            default:
                fatalError()
            }
        }
    }
}
