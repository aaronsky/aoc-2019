import Base

struct Day10: Day {
    var map: AsteroidMap

    init(
        _ input: Input
    ) throws {
        map = input.decode()!
    }

    func partOne() async -> String {
        let asteroid = map.asteroidWithMostOtherAsteroidsVisible()

        return "\(asteroid.countVisible)"
    }

    func partTwo() async -> String {
        let station = Point2(x: 20, y: 18)
        let twoHundredthAsteroid = map.vaporizeAsteroids(from: station)

        return "\((twoHundredthAsteroid.x * 100) + twoHundredthAsteroid.y)"
    }

    struct AsteroidMap: RawRepresentable {
        var asteroids: [Point2]
        var width: Int
        var height: Int

        var rawValue: String {
            ""
        }

        subscript(x: Int, y: Int) -> Point2 {
            asteroids[self.width * x + y]
        }

        init(
            asteroids: [Point2],
            width: Int,
            height: Int
        ) {
            self.asteroids = asteroids
            self.width = width
            self.height = height
        }

        init?(
            rawValue: String
        ) {
            var width = 0
            var height = 0

            let asteroids =
                rawValue
                .components(separatedBy: "\n")
                .enumerated()
                .flatMap { (y: Int, row: String) -> [Point2] in
                    height = max(y, height)
                    let rows =
                        row
                        .enumerated()
                        .compactMap { (x: Int, coord: Character) -> Point2? in
                            switch Body(rawValue: String(coord)) {
                            case .asteroid:
                                return Point2(x: x, y: y)
                            default:
                                return nil
                            }
                        }
                    width = max(rows.count, width)
                    return rows
                }

            self.init(asteroids: asteroids, width: width, height: height)
        }

        typealias VisibleAsteroid = (coord: Point2, countVisible: Int)

        func asteroidWithMostOtherAsteroidsVisible() -> VisibleAsteroid {
            var max: VisibleAsteroid?

            for asteroid in asteroids {
                let countVisible = numberOfVisibleAsteroids(from: asteroid)
                switch max {
                case .some((_, let visible)) where countVisible > visible:
                    max = (asteroid, countVisible)
                case .some:
                    break
                case .none:
                    max = (asteroid, countVisible)
                }
            }

            return max!
        }

        private func numberOfVisibleAsteroids(from asteroid: Point2) -> Int {
            var angles: Set<Double> = []
            for other in asteroids {
                let angle = other.polarAngle(to: asteroid)
                angles.insert(angle)
            }
            return angles.count
        }

        func vaporizeAsteroids(from coord: Point2) -> Point2 {
            var angles: [Double: [Point2]] = [:]
            for asteroid in asteroids {
                let angle = (asteroid.polarAngle(to: coord) + Double.tau).truncatingRemainder(dividingBy: Double.tau)
                angles[angle, default: []].append(asteroid)
            }

            var sortedAngles: [Double] = []
            for (angle, _) in angles {
                sortedAngles.append(angle)
                angles[angle]?
                    .sort(by: { (a, b) in
                        a.manhattanDistance(to: coord) < b.manhattanDistance(to: coord)
                    })
            }

            sortedAngles.sort()

            var angleIndex = sortedAngles.firstIndex(where: {
                $0 >= Double.tau / 4.0
            })!

            var mostRecentlyVaporized = Point2.zero
            for _ in 0..<200 {
                var nextAngle = sortedAngles[angleIndex]
                while angles[nextAngle] == nil || angles[nextAngle]?.isEmpty == true {
                    angleIndex += 1
                    nextAngle = sortedAngles[angleIndex]
                }
                mostRecentlyVaporized = angles[nextAngle]!.removeFirst()
                angleIndex += 1
                angleIndex %= sortedAngles.count
            }

            return mostRecentlyVaporized
        }
    }

    enum Body: RawRepresentable {
        case space
        case asteroid

        var rawValue: String {
            switch self {
            case .space:
                return "."
            case .asteroid:
                return "#"
            }
        }

        init?(
            rawValue: String
        ) {
            switch rawValue {
            case ".":
                self = .space
            case "#":
                self = .asteroid
            default:
                return nil
            }
        }
    }
}
