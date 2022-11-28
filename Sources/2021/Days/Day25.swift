import Algorithms
import Base

struct Day25: Day {
    var floor: Seafloor

    init(_ input: Input) throws {
        floor = input.decode()!
    }

    func partOne() async -> String {
        var floor = floor
        let count = floor.stepUntilStable()

        return "\(count)"
    }

    func partTwo() async -> String {
        ""
    }

    struct Seafloor: RawRepresentable {
        var eastCukes: Set<Point2> = []
        var southCukes: Set<Point2> = []
        var width: Int
        var height: Int

        var rawValue: String {
            ""
        }

        init?(rawValue: String) {
            let lines = rawValue.components(separatedBy: "\n")

            guard let width = lines.first?.count else {
                return nil
            }
            let height = lines.count

            for (y, line) in lines.enumerated() {
                for (x, c) in line.enumerated() {
                    if c == ">" {
                        eastCukes.insert(Point2(x: x, y: y))
                    } else if c == "v" {
                        southCukes.insert(Point2(x: x, y: y))
                    }
                }
            }

            self.width = width
            self.height = height
        }

        mutating func stepUntilStable() -> Int {
            var stepNumber = 0
            var hasChanged = true

            while hasChanged {
                hasChanged = step()
                stepNumber += 1
            }

            return stepNumber
        }

        mutating func step() -> Bool {
            var newEast: Set<Point2> = []
            var newSouth: Set<Point2> = []

            for cuke in eastCukes {
                let newPosition = Point2(x: (cuke.x + 1) % width, y: cuke.y)
                if !eastCukes.contains(newPosition) &&
                    !southCukes.contains(newPosition) {
                    newEast.insert(newPosition)
                } else {
                    newEast.insert(cuke)
                }
            }

            for cuke in southCukes {
                let newPosition = Point2(x: cuke.x, y: (cuke.y + 1) % height)
                if !southCukes.contains(newPosition) &&
                    !newEast.contains(newPosition) {
                    newSouth.insert(newPosition)
                } else {
                    newSouth.insert(cuke)
                }
            }

            if eastCukes == newEast && southCukes == newSouth {
                return false
            }

            eastCukes = newEast
            southCukes = newSouth

            return true
        }
    }
}
