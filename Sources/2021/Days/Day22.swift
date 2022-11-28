import Algorithms
import Base
import RegexBuilder

struct Day22: Day {
    var reactor: Reactor

    init(
        _ input: Input
    ) throws {
        reactor = input.decode()!
    }

    func partOne() async -> String {
        "\(reactor.reboot(initializationAreaOnly: true))"
    }

    func partTwo() async -> String {
        "\(reactor.reboot(initializationAreaOnly: false))"
    }

    struct Reactor: RawRepresentable {
        struct RebootStep: RawRepresentable {
            enum State: String {
                case off
                case on
            }

            var state: State
            var cube: Cube

            var rawValue: String {
                "\(state.rawValue) x=\(cube.x.lowerBound)..\(cube.x.upperBound),y=\(cube.y.lowerBound)..\(cube.y.upperBound),z=\(cube.z.lowerBound)..\(cube.z.upperBound)"
            }

            init(
                state: State,
                cube: Cube
            ) {
                self.state = state
                self.cube = cube
            }

            init(
                state: State,
                x: ClosedRange<Int>,
                y: ClosedRange<Int>,
                z: ClosedRange<Int>
            ) {
                self.init(state: state, cube: Cube(x: x, y: y, z: z))
            }

            init?(
                rawValue: String
            ) {
                let stateRef = Reference<Substring>()
                let minXRef = Reference<Int>()
                let maxXRef = Reference<Int>()
                let minYRef = Reference<Int>()
                let maxYRef = Reference<Int>()
                let minZRef = Reference<Int>()
                let maxZRef = Reference<Int>()
                let pattern = Regex {
                    Capture(as: stateRef) {
                        ChoiceOf {
                            "on"
                            "off"
                        }
                    }
                    " x="
                    TryCapture(as: minXRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ".."
                    TryCapture(as: maxXRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ",y="
                    TryCapture(as: minYRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ".."
                    TryCapture(as: maxYRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ",z="
                    TryCapture(as: minZRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ".."
                    TryCapture(as: maxZRef) {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                }
                guard
                    let match = try? pattern.firstMatch(in: rawValue),
                    let state = State(rawValue: String(match[stateRef]))
                else {
                    return nil
                }

                let (xMin, xMax) = (match[minXRef], match[maxXRef])
                let (yMin, yMax) = (match[minYRef], match[maxYRef])
                let (zMin, zMax) = (match[minZRef], match[maxZRef])

                self.init(state: state, x: xMin...xMax, y: yMin...yMax, z: zMin...zMax)
            }
        }

        struct Cube: Hashable {
            var x: ClosedRange<Int>
            var y: ClosedRange<Int>
            var z: ClosedRange<Int>

            var volume: Int {
                x.count * y.count * z.count
            }

            init(
                x: ClosedRange<Int>,
                y: ClosedRange<Int>,
                z: ClosedRange<Int>
            ) {
                self.x = x
                self.y = y
                self.z = z
            }
        }

        var steps: [RebootStep]

        var rawValue: String {
            steps
                .map { $0.rawValue }
                .joined(separator: "\n")
        }

        init(
            steps: [RebootStep]
        ) {
            self.steps = steps
        }

        init?(
            rawValue: String
        ) {
            steps =
                rawValue
                .components(separatedBy: "\n")
                .compactMap(RebootStep.init)
        }

        func reboot(initializationAreaOnly: Bool) -> Int {
            let initializationArea = -50...50

            var cubes: CountedSet<Cube> = []

            for step in steps
            where
                !initializationAreaOnly
                || (initializationAreaOnly
                    && (initializationArea.contains(step.cube.x.lowerBound)
                        && initializationArea.contains(step.cube.x.upperBound))
                    && (initializationArea.contains(step.cube.y.lowerBound)
                        && initializationArea.contains(step.cube.y.upperBound))
                    && (initializationArea.contains(step.cube.z.lowerBound)
                        && initializationArea.contains(step.cube.z.upperBound)))
            {

                var updates: CountedSet<Cube> = []

                for (cube, mode) in cubes {
                    let subXMin = max(step.cube.x.lowerBound, cube.x.lowerBound)
                    let subXMax = min(step.cube.x.upperBound, cube.x.upperBound)
                    let subYMin = max(step.cube.y.lowerBound, cube.y.lowerBound)
                    let subYMax = min(step.cube.y.upperBound, cube.y.upperBound)
                    let subZMin = max(step.cube.z.lowerBound, cube.z.lowerBound)
                    let subZMax = min(step.cube.z.upperBound, cube.z.upperBound)
                    if subXMin <= subXMax && subYMin <= subYMax && subZMin <= subZMax {
                        updates[Cube(x: subXMin...subXMax, y: subYMin...subYMax, z: subZMin...subZMax)] -= mode
                    }
                }

                if step.state == .on {
                    updates[step.cube] += 1
                }

                for (element, count) in updates {
                    cubes[element] += count
                }
            }

            return cubes.sum { (cube, sign) in
                sign * cube.volume
            }
        }
    }
}
