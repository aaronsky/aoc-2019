import Algorithms
import Base
import RegexBuilder

struct Day4: Day {
    var indexPairs: [(ClosedRange<Int>, ClosedRange<Int>)]

    init(_ input: Input) throws {
        let min1Ref = Reference<Int>()
        let max1Ref = Reference<Int>()
        let min2Ref = Reference<Int>()
        let max2Ref = Reference<Int>()
        let pattern = Regex {
            TryCapture(OneOrMore(.digit), as: min1Ref, transform: {
                Int($0)
            })
            "-"
            TryCapture(OneOrMore(.digit), as: max1Ref, transform: {
                Int($0)
            })
            ","
            TryCapture(OneOrMore(.digit), as: min2Ref, transform: {
                Int($0)
            })
            "-"
            TryCapture(OneOrMore(.digit), as: max2Ref, transform: {
                Int($0)
            })
        }
        indexPairs = input.decodeMany(separatedBy: "\n") { line in
            guard let match = try? pattern.firstMatch(in: line) else { return nil }
            return (match[min1Ref]...match[max1Ref], match[min2Ref]...match[max2Ref])
        }
    }

    func partOne() async -> String {
        "\(indexPairs.count(where: { $0.0.contains($0.1) || $0.1.contains($0.0) }))"
    }

    func partTwo() async -> String {
        "\(indexPairs.count(where: { $0.0.overlaps($0.1) || $0.1.overlaps($0.0) }))"
    }
}
