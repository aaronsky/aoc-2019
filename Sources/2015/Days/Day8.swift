import Base

struct Day8: Day {
    var strings: [String]

    init(
        _ input: Input
    ) throws {
        strings =
            input
            .components(separatedBy: "\n")
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func partOne() async -> String {
        let one = strings.sum { $0.count - lengthInMemory($0) }

        return "\(one)"
    }

    func partTwo() async -> String {
        let two = strings.sum { encodeString($0).count - $0.count }

        return "\(two)"
    }

    func lengthInMemory(_ str: String) -> Int {
        var count = 0
        var chars = str.makeIterator()
        while let c = chars.next() {
            switch c {
            case "\"":
                continue
            case "\\":
                switch chars.next() {
                case "\\":
                    break
                case "\"":
                    break
                case "x":
                    assert(chars.next()?.isHexDigit == true)
                    assert(chars.next()?.isHexDigit == true)
                default:
                    fatalError("impossible input")
                }
            default:
                break
            }

            count += 1
        }

        return count
    }

    func encodeString(_ str: String) -> String {
        var encoded = String()

        encoded.append("\"")
        encoded = str.reduce(into: encoded) { acc, c in
            switch c {
            case "\"":
                acc.append(#"\""#)
            case "\\":
                acc.append(#"\\"#)
            default:
                acc.append(c)
            }
        }
        encoded.append("\"")

        return encoded
    }
}
