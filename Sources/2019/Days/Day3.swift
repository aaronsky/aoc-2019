import Algorithms
import Base

struct Day3: Day {
    var wireOne: Wire
    var wireTwo: Wire

    init(_ input: Input) throws {
        let wires = input
            .components(separatedBy: "\n")
            .prefix(2)
            .compactMap(Wire.init)
        assert(wires.count == 2)
        (wireOne, wireTwo) = (wires[0], wires[1])
    }

    func partOne() async -> String {
        let wireOnePath = Dictionary(wireOne.zip(1...),
                                     uniquingKeysWith: { (_, last) in last })
        let distance = wireTwo
            .zip(1...)
            .compactMap { (cursor, idx) in
                wireOnePath[cursor].map { idx + $0 }
            }
            .min()

        guard let distance = distance else {
            preconditionFailure("no distances in path")
        }

        return "\(distance)"
    }

    func partTwo() async -> String {
        ""
    }

    struct Wire: RawRepresentable, Sequence {
        var nodes: [Node]

        var rawValue: String {
            nodes
                .map { $0.rawValue }
                .joined(separator: ",")
        }

        init?(rawValue: String) {
            nodes = rawValue
                .components(separatedBy: ",")
                .compactMap(Node.init)
        }

        func makeIterator() -> Array<Point2>.Iterator {
            nodes
                .flatMap { repeatElement($0.direction, count: $0.length) }
                .reductions(into: Point2.zero) { cursor, direction in
                    cursor.move(direction: direction)
                }.makeIterator()
        }

        struct Node: RawRepresentable {
            var direction: Direction
            var length: Int

            var rawValue: String {
                "\(direction.rawValue)\(length)"
            }

            init?(rawValue: String) {
                let (dirID, len) = (rawValue.prefix(1), rawValue.dropFirst())

                guard let direction = Direction(rawValue: String(dirID)) else {
                    return nil
                }
                self.direction = direction

                guard let length = Int(len) else {
                    return nil
                }
                self.length = length
            }
        }
    }
}

extension Direction: RawRepresentable {
    var rawValue: String {
        switch self {
        case .up:
            return "U"
        case .down:
            return "D"
        case .left:
            return "L"
        case .right:
            return "R"
        }
    }

    init?(rawValue: String) {
        switch rawValue {
        case "U":
            self = .up
        case "D":
            self = .down
        case "L":
            self = .left
        case "R":
            self = .right
        default:
            fatalError("bad direction \(rawValue)")
        }
    }
}
