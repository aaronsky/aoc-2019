import Algorithms
import Base

struct Day1: Day {
    var elves: [Int]

    init(
        _ input: Input
    ) throws {
        self.elves = input
            .lines
            .split(on: \.isEmpty)
            .map(\.integers.sum)
    }

    func partOne() async -> String {
        "\(elves.max()!)"
    }

    func partTwo() async -> String {
        "\(elves.max(count: 3).sum)"
    }
}
