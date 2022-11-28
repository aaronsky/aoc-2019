import Base
import RegexBuilder

struct Day5: Day {
    var vents: [Vent]

    init(
        _ input: Input
    ) throws {
        self.init(vents: input.decodeMany(separatedBy: "\n"))
    }

    init(
        vents: [Vent]
    ) {
        self.vents = vents
    }

    func partOne() async -> String {
        "\(countCoincidentPoints(in: vents.filter { $0.isHorizontal || $0.isVertical }))"
    }

    func partTwo() async -> String {
        "\(countCoincidentPoints(in: vents))"
    }

    func countCoincidentPoints(in vents: [Vent]) -> Int {
        vents
            .flatMap(\.points)
            .reduce(into: [:]) { acc, point in
                acc[point, default: 0] += 1
            }
            .count(where: {
                $0.value > 1
            })
    }

    struct Vent: RawRepresentable {
        var start: Point2
        var end: Point2

        var isHorizontal: Bool {
            start.y == end.y
        }

        var isVertical: Bool {
            start.x == end.x
        }

        var points: [Point2] {
            if isHorizontal {
                return (min(start.x, end.x)...max(start.x, end.x))
                    .map { Point2(x: $0, y: start.y) }
            } else if isVertical {
                return (min(start.y, end.y)...max(start.y, end.y))
                    .map { Point2(x: start.x, y: $0) }
            } else {
                var points: [Point2] = []

                let (startX, endX) = (min(start.x, end.x), max(start.x, end.x))
                let slope = (start.y - end.y) / (start.x - end.x)
                var y = start.x < end.x ? start.y : end.y

                for x in startX...endX {
                    points.append(Point2(x: x, y: y))
                    y += slope
                }

                return points
            }
        }

        var rawValue: String {
            "\(start.x),\(start.y) -> \(end.x),\(end.y)"
        }

        init(
            startX: Int,
            startY: Int,
            endX: Int,
            endY: Int
        ) {
            self.start = Point2(x: startX, y: startY)
            self.end = Point2(x: endX, y: endY)
        }

        init?(
            rawValue: String
        ) {
            let pattern = Regex {
                TryCapture {
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }
                ","
                TryCapture {
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }

                " -> "

                TryCapture {
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }
                ","
                TryCapture {
                    OneOrMore(.digit)
                } transform: {
                    Int($0)
                }
            }

            guard let match = try? pattern.firstMatch(in: rawValue) else {
                return nil
            }

            self.init(startX: match.1, startY: match.2, endX: match.3, endY: match.4)
        }
    }
}
