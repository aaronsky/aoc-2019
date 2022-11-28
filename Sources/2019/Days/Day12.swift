import Base
import RegexBuilder

struct Day12: Day {
    var system: LunarSystem

    init(_ input: Input) throws {
        system = input.decode()!
    }

    func partOne() async -> String {
        var system = system
        system.simulate(continueHandler: { $0.step < 1000 })

        return "\(system.totalEnergy)"
    }

    func partTwo() async -> String {
        var system = system
        let minCycles = system.findMinimumCycles()

        return "\(minCycles)"
    }

    struct LunarSystem: RawRepresentable {
        struct Moon: RawRepresentable {
            var position: Point3
            var velocity: Point3 = .zero

            var totalEnergy: Int {
                potentialEnergy * kineticEnergy
            }

            var potentialEnergy: Int {
                abs(position.x) + abs(position.y) + abs(position.z)
            }

            var kineticEnergy: Int {
                abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
            }

            init(position: Point3) {
                self.position = position
            }

            var rawValue: String {
                ""
            }

            init?(rawValue: String) {
                let pattern = Regex {
                    "<x="
                    TryCapture {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ", y="
                    TryCapture {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ", z="
                    TryCapture {
                        Optionally("-")
                        OneOrMore(.digit)
                    } transform: {
                        Int($0)
                    }
                    ">"
                }

                guard let match = try? pattern.firstMatch(in: rawValue) else {
                    return nil
                }

                self.init(position: .init(x: match.1, y: match.2, z: match.3))
            }

            mutating func applyGravity(_ other: Moon) {
                velocity += Point3(
                    x: (other.position.x - position.x).signum(),
                    y: (other.position.y - position.y).signum(),
                    z: (other.position.z - position.z).signum()
                )
            }

            mutating func step() {
                position += velocity
            }
        }

        var io: Moon
        var europa: Moon
        var ganymede: Moon
        var callisto: Moon
        var step = 1

        var totalEnergy: Int {
            io.totalEnergy +
            europa.totalEnergy +
            ganymede.totalEnergy +
            callisto.totalEnergy
        }

        var rawValue: String {
            ""
        }

        init?(rawValue: String) {
            var moons = rawValue
                .components(separatedBy: "\n")
                .prefix(4)
                .compactMap(Moon.init)
            precondition(moons.count == 4)

            io = moons.removeFirst()
            europa = moons.removeFirst()
            ganymede = moons.removeFirst()
            callisto = moons.removeFirst()
        }

        mutating func simulate(continueHandler: (Self) -> Bool) {
            while true {
                io.applyGravity(europa)
                io.applyGravity(ganymede)
                io.applyGravity(callisto)
                europa.applyGravity(io)
                europa.applyGravity(ganymede)
                europa.applyGravity(callisto)
                ganymede.applyGravity(io)
                ganymede.applyGravity(europa)
                ganymede.applyGravity(callisto)
                callisto.applyGravity(io)
                callisto.applyGravity(europa)
                callisto.applyGravity(ganymede)

                io.step()
                europa.step()
                ganymede.step()
                callisto.step()

                guard continueHandler(self) else {
                    break
                }

                step += 1
            }
        }

        mutating func findMinimumCycles() -> Int {
            let ioInitial = io
            let europaInitial = europa
            let ganymedeInitial = ganymede
            let callistoInitial = callisto
            var steps: [Int?] = [nil, nil, nil]

            simulate(continueHandler: { sys in
                var shouldContinue = false

                if steps[0] == nil {
                    if sys.io.position.x == ioInitial.position.x &&
                        sys.io.velocity.x == ioInitial.velocity.x &&
                        sys.europa.position.x == europaInitial.position.x &&
                        sys.europa.velocity.x == europaInitial.velocity.x &&
                        sys.ganymede.position.x == ganymedeInitial.position.x &&
                        sys.ganymede.velocity.x == ganymedeInitial.velocity.x &&
                        sys.callisto.position.x == callistoInitial.position.x &&
                        sys.callisto.velocity.x == callistoInitial.velocity.x {
                        steps[0] = sys.step
                    } else {
                        shouldContinue = shouldContinue || true
                    }
                }

                if steps[1] == nil {
                    if sys.io.position.y == ioInitial.position.y &&
                        sys.io.velocity.y == ioInitial.velocity.y &&
                        sys.europa.position.y == europaInitial.position.y &&
                        sys.europa.velocity.y == europaInitial.velocity.y &&
                        sys.ganymede.position.y == ganymedeInitial.position.y &&
                        sys.ganymede.velocity.y == ganymedeInitial.velocity.y &&
                        sys.callisto.position.y == callistoInitial.position.y &&
                        sys.callisto.velocity.y == callistoInitial.velocity.y {
                        steps[1] = sys.step
                    } else {
                        shouldContinue = shouldContinue || true
                    }
                }

                if steps[2] == nil {
                    if sys.io.position.z == ioInitial.position.z &&
                        sys.io.velocity.z == ioInitial.velocity.z &&
                        sys.europa.position.z == europaInitial.position.z &&
                        sys.europa.velocity.z == europaInitial.velocity.z &&
                        sys.ganymede.position.z == ganymedeInitial.position.z &&
                        sys.ganymede.velocity.z == ganymedeInitial.velocity.z &&
                        sys.callisto.position.z == callistoInitial.position.z &&
                        sys.callisto.velocity.z == callistoInitial.velocity.z {
                        steps[2] = sys.step
                    } else {
                        shouldContinue = shouldContinue || true
                    }
                }

                return shouldContinue
            })

            guard let step1 = steps[0],
                  let step2 = steps[1],
                  let step3 = steps[2] else {
                      return 0
                  }

            return step1
                .leastCommonMultiple(step2)
                .leastCommonMultiple(step3)
        }
    }
}
