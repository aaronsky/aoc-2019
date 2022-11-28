import Algorithms
import Base

struct Day11: Day {
    var octopuses: Octopuses

    init(_ input: Input) throws {
        octopuses = input.decode()!
    }

    func partOne() async -> String {
        var octopuses = octopuses
        var flashes = 0
        for _ in 1...100 {
            flashes += octopuses.step()
        }
        return "\(flashes)"
    }

    func partTwo() async -> String {
        var octopuses = octopuses
        var step = 0
        for i in 1... {
            step = i
            if octopuses.step() == octopuses.count {
                break
            }
        }
        return "\(step)"
    }

    struct Octopuses: RawRepresentable {
        var octopuses: Matrix<Int>

        var count: Int {
            octopuses.count
        }

        var rawValue: String {
            octopuses.description
        }

        init?(rawValue: String) {
            octopuses = Matrix(rawValue
                                .components(separatedBy: "\n")
                                .flatMap { $0.map { Int(String($0))! } },
                               rowWidth: 10,
                               rows: 10)
        }

        /// - Returns: number of flashes in step
        mutating func step() -> Int {
            for i in octopuses.indices {
                octopuses[i] += 1
            }

            var flashed: Set<Array<Int>.Index> = []

            for i in octopuses.indices where octopuses[i] > 9 && !flashed.contains(i) {
                flashed.insert(i)

                var nextOctos = [i]

                while let next = nextOctos.popLast() {
                    for adjacent in octopuses.indicesSurrounding(index: next, includingDiagonals: true) {
                        octopuses[adjacent] += 1
                        if octopuses[adjacent] > 9 && !flashed.contains(adjacent) {
                            flashed.insert(adjacent)
                            nextOctos.append(adjacent)
                        }
                    }
                }
            }

            for flashedIndex in flashed {
                octopuses[flashedIndex] = 0
            }

            return flashed.count
        }
    }
}
