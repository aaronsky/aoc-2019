import Base

struct Day4: Day {
    var range: PasswordRange

    init(_ input: Input) throws {
        range = input.decode()!
    }

    func partOne() async -> String {
        let possibilities = range.possibilities.count
        return "\(possibilities)"
    }

    func partTwo() async -> String {
        ""
    }

    struct PasswordRange: RawRepresentable {
        var start: Int
        var end: Int

        var rawValue: String {
            "\(start)-\(end)"
        }

        var possibilities: [Int] {
            (start..<end)
                .filter(self.isValid)
        }

        init?(rawValue: String) {
            let components = rawValue
                .components(separatedBy: "-")
                .prefix(2)
                .compactMap(Int.init)
            precondition(components.count == 2, "insufficient number of components in \(rawValue)")
            self.init(start: components[0], end: components[1])
        }

        init(start: Int, end: Int) {
            self.start = start
            self.end = end
        }

        func isValid(_ candidate: Int) -> Bool {
            let numDigits = candidate.countDigits

            precondition(numDigits == 6)
            precondition(candidate >= start && candidate <= end)

            var valid = true
            var adjacentSequence = ""
            var foundSequenceOfExactlyTwoDigits = false
            var lastNumber = Int.max

            for digit in candidate.digits {
                if lastNumber == Int.max {
                    adjacentSequence.append("\(digit)")
                } else if digit < lastNumber {
                    valid = false
                    break
                } else if digit == lastNumber {
                    adjacentSequence.append("\(digit)")
                } else {
                    foundSequenceOfExactlyTwoDigits = foundSequenceOfExactlyTwoDigits || adjacentSequence.count == 2
                    adjacentSequence = "\(digit)"
                }
                lastNumber = digit
            }

            foundSequenceOfExactlyTwoDigits = foundSequenceOfExactlyTwoDigits || adjacentSequence.count == 2

            return valid && foundSequenceOfExactlyTwoDigits
        }
    }
}
