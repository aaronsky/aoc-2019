import Base

struct Day3: Day {
    var numbers: [[Bool]]
    var numberLength: Int

    init(
        _ input: Input
    ) throws {
        numbers = input.components(separatedBy: "\n").map { $0.map { $0 == "1" ? true : false } }
        numberLength = numbers.first!.count
    }

    func partOne() async -> String {
        var gamma: [Bool] = []
        var epsilon: [Bool] = []

        for i in 0..<numberLength {
            let mostCommon = numbers.count(where: { $0[i] })
            let leastCommon = numbers.count - mostCommon

            gamma.append(mostCommon > leastCommon)
            epsilon.append(mostCommon < leastCommon)
        }

        let g = Int(bits: gamma)
        let e = Int(bits: epsilon)

        return "\(g * e)"
    }

    func partTwo() async -> String {
        func rate(_ numbers: inout [[Bool]], index: Int, comparator: (Int, Int) -> Bool) {
            let mostCommon = numbers.count(where: { $0[index] })
            let leastCommon = numbers.count - mostCommon
            let value = comparator(mostCommon, leastCommon)
            numbers = numbers.filter { $0[index] == value }
        }

        var o2Remaining = numbers
        var co2Remaining = numbers

        for i in 0..<numberLength {
            if o2Remaining.count > 1 {
                rate(&o2Remaining, index: i, comparator: >=)
            }

            if co2Remaining.count > 1 {
                rate(&co2Remaining, index: i, comparator: <)
            }
        }

        guard let o2Rating = o2Remaining.first,
            let co2Rating = co2Remaining.first
        else {
            preconditionFailure("Missing ratings in data sets.")
        }

        let o2 = Int(bits: o2Rating)
        let co2 = Int(bits: co2Rating)

        return "\(o2 * co2)"
    }
}
