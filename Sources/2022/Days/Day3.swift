import Algorithms
import Base

struct Day3: Day {
    var sacks: [String]

    init(_ input: Input) throws {
        sacks = input.lines
    }

    func partOne() async -> String {
        let sum = sacks
            .map { $0.split(at: $0.middleIndex) }
            .compactMap {
                [$0.left, $0.right]
                    .intersection
                    .first
            }
            .sum(of: \.priority)

        return "\(sum)"
    }

    func partTwo() async -> String {
        let sum = sacks
            .chunks(ofCount: 3)
            .compactMap { $0.intersection.first }
            .sum(of: \.priority)

        return "\(sum)"
    }
}

extension Character {
    fileprivate var priority: Int {
        isLowercase ? alphabeticalOrdinal! : alphabeticalOrdinal! + 26
    }
}
