import Algorithms
import Base

struct Day1: Day {
    var elves: [LunchBox]

    init(_ input: Input) throws {
        self.elves = []

        var boxes: [Int] = []
        for line in input.raw.components(separatedBy: "\n") {
            if line.isEmpty {
                elves.append(.init(boxes: boxes))
                boxes = []
            } else if let calories = Int(line) {
                boxes.append(calories)
            }
        }
    }

    func partOne() async -> String {
        "\(elves.max(by: { $0.sum < $1.sum })!.sum)"
    }

    func partTwo() async -> String {
        "\(elves.max(count: 3, sortedBy: { $0.sum < $1.sum }).sum(of: \.sum))"
    }

    struct LunchBox {
        var boxes: [Int] {
            didSet {
                sum = boxes.reduce(0, +)
            }
        }

        var sum: Int = 0

        init(boxes: [Int]) {
            self.boxes = boxes
            self.sum = boxes.reduce(0, +)
        }
    }
}
