//
//  Day4.swift
//  
//
//  Created by Aaron Sky on 11/24/21.
//

import Algorithms
import Base

struct Day4: Day {
    var rooms: [Room]

    init(_ input: Input) throws {
        rooms = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        let realRooms = rooms
            .filter(\.isReal)
            .sum(of: \.sectorID)

        return "\(realRooms)"
    }

    func partTwo() async -> String {
        ""
    }

    struct Room: RawRepresentable {
        static let pattern = Regex(#"([a-z-]*)-(\d*)\[([a-z]*)\]"#)

        var name: String
        var sectorID: Int
        var checksum: String

        /**
         A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization.
         */
        var isReal: Bool {
            name
                .reduce(into: [Character: Int]()) { acc, c in
                    acc[c, default: 0] += 1
                }
                .max(count: 5) { a, b in
                    if a.value > b.value {
                        return true
                    } else if a.value < b.value {
                        return false
                    } else {
                        return a.key < b.key
                    }
                }
                .zip(checksum)
                .allSatisfy {
                    let ((c, _), check) = $0
                    return c == check
                }
        }

        var rawValue: String {
            "\(name)-\(sectorID)[\(checksum)]"
        }

        init(name: String, sectorID: Int, checksum: String) {
            self.name = name
            self.sectorID = sectorID
            self.checksum = checksum
        }

        init?(rawValue: String) {
            guard let match = Room.pattern.firstMatch(in: rawValue) else {
                return nil
            }

            let captures = match.captures.prefix(3)
            precondition(captures.count == 3)

            guard let name = captures[0]?.replacingOccurrences(of: "-", with: ""),
                  let sectorIDString = captures[1],
                  let sectorID = Int(sectorIDString),
                  let checksum = captures[2] else {
                      return nil
                  }

            self.init(name: name, sectorID: sectorID, checksum: checksum)
        }
    }
}
