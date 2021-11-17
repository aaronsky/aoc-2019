//
//  Day8.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day8: Day {
    var strings: [String]

    init(_ input: Input) throws {
        strings = try input
            .decodeMany(separatedBy: "\n")
            .map { (s: String) in
                s.trimmingCharacters(in: .whitespacesAndNewlines)
            }
    }

    func partOne() -> String {
        let one = strings.map {
            $0.count - lengthInMemory($0)
        }.reduce(0, +)

        return "\(one)"
    }

    func partTwo() -> String {
        let two = strings.map {
            encodeString($0).count - $0.count
        }.reduce(0, +)

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
