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
            .filter { $0.isReal }
            .map { $0.sectorID }
            .reduce(0, +)
        return "\(realRooms)"
    }

    func partTwo() async -> String {
        ""
    }

    struct Room: RawRepresentable {
        var name: [Character: Int]
        var sectorID: Int
        var checksum: String

        /**
         A room is real (not a decoy) if the checksum is the five most common letters in the encrypted name, in order, with ties broken by alphabetization.

           - aaaaa-bbb-z-y-x-123[abxyz] is a real room because the most common letters are a (5), b (3), and then a tie between x, y, and z, which are listed alphabetically.
           - a-b-c-d-e-f-g-h-987[abcde] is a real room because although the letters are all tied (1 of each), the first five are listed alphabetically.
           - not-a-real-room-404[oarel] is a real room.
           - totally-real-room-200[decoy] is not.
         */
        var isReal: Bool {
            let topChars = name
                .max(count: 5) { $0.value > $1.value }
            print(topChars)
            for (c, count) in topChars {
                guard c == checksum.first! else {
                    return false
                }
            }
            return true
        }

        var rawValue: String {
            "\(name)-\(sectorID)[\(checksum)]"
        }

        init(name: [Character: Int], sectorID: Int, checksum: String) {
            self.name = name
            self.sectorID = sectorID
            self.checksum = checksum
        }

        init?(rawValue: String) {
            enum ParseState {
                case name
                case sectorID
                case checksum
            }

            var state: ParseState = .name
            var name: [Character: Int] = [:]
            var sectorID = 0
            var checksum = ""

            for l in rawValue {
                if l.isNumber {
                    if state == .checksum {
                        return nil
                    } else if state == .name {
                        state = .sectorID
                    }

                    guard let n = Int(String(l)) else {
                        return nil
                    }

                    sectorID = sectorID * 10 + n

                    continue
                } else if l == "[" && state == .sectorID {
                    state = .checksum
                } else if l == "]" {
                    break
                }

                if state == .name {
                    name[l, default: 0] += 1
                } else if state == .checksum {
                    checksum.append(l)
                } else if state == .sectorID {
                    return nil
                }
            }

            self.init(name: name, sectorID: sectorID, checksum: checksum)
        }
    }
}
