import Algorithms
import Base

struct Day3: Day {
    var sacks: [String]

    init(_ input: Input) throws {
        sacks = input.lines.dropLast()
    }

    func partOne() async -> String {
        let sum = sacks
            .map { $0.split(at: $0.middleIndex) }
            .compactMap {
                Set($0.left)
                    .intersection(Set($0.right))
                    .first
            }
            .sum(of: itemValue(_:))

        return "\(sum)"
    }

    func partTwo() async -> String {
        let sum = sacks
            .chunks(ofCount: 3)
            .compactMap { sacks in
                Set(sacks[sacks.startIndex])
                    .intersection(Set(sacks[sacks.index(after: sacks.startIndex)]))
                    .intersection(Set(sacks[sacks.index(before: sacks.endIndex)]))
                    .first
            }
            .sum(of: itemValue(_:))

        return "\(sum)"
    }

    func itemValue(_ c: Character) -> Int {
        guard let cv = c.asciiValue else { fatalError() }
        switch cv {
        case 65...90:
            return Int(cv) - 38
        case 97...122:
            return Int(cv) - 96
        default:
            fatalError()
        }
    }
}
