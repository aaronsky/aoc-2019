import Algorithms
import Base

struct Day7: Day {
    var crabs: [Int]

    init(_ input: Input) throws {
        crabs = input.decodeMany(separatedBy: ",")
    }

    func partOne() async -> String {
        "\(fuelRequired() ?? -1)"
    }

    func partTwo() async -> String {
        "\(fuelRequired(triangular: true) ?? -1)"
    }

    func fuelRequired(triangular: Bool = false) -> Int? {
        guard let (min, max) = crabs.minAndMax() else {
            return nil
        }

        func fuelCost(_ crab: Int) -> Int {
            crabs.sum {
                let diff = abs($0 - crab)
                return triangular ? diff.triangularSum : diff
            }
        }

        return (min...max)
            .lazy
            .map(fuelCost)
            .min()
    }
}
