import Algorithms
import Base
import RegexBuilder

struct Day9: Day {
    enum Direction: String, Hashable {
        case up = "U"
        case down = "D"
        case left = "L"
        case right = "R"

        var delta: Vector2 {
            switch self {
            case .up:
                return .init(x: 0, y: -1)
            case .down:
                return .init(x: 0, y: 1)
            case .left:
                return .init(x: -1, y: 0)
            case .right:
                return .init(x: 1, y: 0)
            }
        }
    }

    let instructions: [(direction: Direction, steps: Int)]

    init(
        _ input: Input
    ) throws {
        instructions = input.decodeMany(separatedBy: "\n") {
            let comps = $0.split(separator: " ")
            guard let direction = Direction(rawValue: String(comps[0])), let steps = Int(comps[1]) else {
                return nil
            }
            return (direction, steps)
        }
    }

    func partOne() async -> String {
        "\(visitedOnRope(ofLength: 2))"
    }

    func partTwo() async -> String {
        "\(visitedOnRope(ofLength: 10))"
    }

    func visitedOnRope(ofLength length: Int) -> Int {
        guard length > 0 else { return 0 }

        var rope: [Point2] = Array(repeating: .zero, count: length)
        var tailVisited: Set<Point2> = [rope.last!]

        for instruction in instructions {
            let steps = Array(repeating: instruction.direction.delta, count: instruction.steps)
            for step in steps {
                rope[0] += step

                for (p, n) in rope.indices.adjacentPairs() {
                    let vec = rope[n].vector(towards: rope[p])
                    if vec.manhattanDistance > (vec.isOrthogonal ? 1 : 2) {
                        rope[n] += vec.unit
                    }
                }

                tailVisited.insert(rope.last!)
            }
        }

        return tailVisited.count
    }
}
