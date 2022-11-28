import Algorithms
import Base
import OrderedCollections

struct Day1: Day {
    var directives: [Directive]

    init(_ input: Input) throws {
        directives = input.decodeMany(separatedBy: ", ")
    }

    func partOne() async -> String {
        var cursor = Cursor()

        for directive in directives {
            cursor.move(directive)
        }

        return "\(cursor.currentPosition.manhattanDistance(to: .zero))"
    }

    func partTwo() async -> String {
        var cursor = Cursor()

        for directive in directives {
            cursor.move(directive)
        }

        guard let previouslyVisited = cursor.history.first(where: { $0.1 > 1 })?.key else {
            return ""
        }

        return "\(previouslyVisited.manhattanDistance(to: .zero))"
    }

    struct Directive: RawRepresentable {
        enum TurnDirection: String {
            case left = "L"
            case right = "R"
        }

        var turn: TurnDirection
        var spaces: Int

        var rawValue: String {
            "\(turn.rawValue)\(spaces)"
        }

        init?(rawValue: String) {
            var rawValue = rawValue

            let direction = rawValue.removeFirst()

            guard let turn = TurnDirection(rawValue: String(direction)) else {
                return nil
            }

            guard let spaces = Int(rawValue) else {
                return nil
            }

            self.init(turn: turn, spaces: spaces)
        }

        init(turn: TurnDirection, spaces: Int) {
            self.turn = turn
            self.spaces = spaces
        }
    }

    struct Cursor {
        var currentDirection: Direction
        var currentPosition: Point2

        var history: OrderedDictionary<Point2, Int> = [Point2.zero: 1]

        init() {
            currentPosition = .zero
            currentDirection = .north
        }

        mutating func move(_ directive: Directive) {
            currentDirection = currentDirection.turning(directive.turn)
            for _ in 0..<directive.spaces {
                switch currentDirection {
                case .north:
                    currentPosition.y -= 1
                case .south:
                    currentPosition.y += 1
                case .west:
                    currentPosition.x -= 1
                case .east:
                    currentPosition.x += 1
                }

                history[currentPosition, default: 0] += 1
            }
        }

        enum Direction {
            case north
            case west
            case south
            case east

            func turning(_ direction: Directive.TurnDirection) -> Self {
                switch (self, direction) {
                case (.north, .left):
                    return .west
                case (.north, .right):
                    return .east
                case (.west, .left):
                    return .south
                case (.west, .right):
                    return .north
                case (.south, .left):
                    return .east
                case (.south, .right):
                    return .west
                case (.east, .left):
                    return .north
                case (.east, .right):
                    return .south
                }
            }
        }
    }
}
