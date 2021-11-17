//
//  Day4.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base
import CryptoKit

struct Day4: Day {
    var key: String

    init(_ input: Input) throws {
        key = input.raw
    }

    func partOne() -> String {
//        "\(lowestNumberInHash("00000") ?? -1)"
        ""
    }

    func partTwo() -> String {
//        "\(lowestNumberInHash("000000") ?? -1)"
        ""
    }

    func lowestNumberInHash(_ start: String) -> Int? {
        for n in 1... {
            guard let input = "\(key)\(n)".data(using: .utf8) else {
                continue
            }
            let hash = Insecure.MD5.hash(data: input)
            let out = hash.map {
                String(format: "%02hhx", $0)
            }.joined()
            if out.hasPrefix(start) {
                return n
            }
        }

        return nil
    }
}
