//
//  Day6.swift
//  
//
//  Created by Aaron Sky on 12/6/21.
//

import Base

struct Day6: Day {
    var fish: [Int]

    init(_ input: Input) throws {
        self.init(fish: input.decodeMany(separatedBy: ",", transform: Int.init))
    }

    init(fish: [Int]) {
        self.fish = fish
    }

    func partOne() async -> String {
        return "\(totalFishAfter(days: 80))"
    }

    func partTwo() async -> String {
        return "\(totalFishAfter(days: 256))"
    }

    func totalFishAfter(days: Int) -> Int {
        var dayCache = Array(repeating: 1, count: 9)

        for _ in 0..<days {
            dayCache = [dayCache[6] + dayCache[8]] + dayCache.dropLast()
        }

        return fish.sum { dayCache[$0] }
    }
}
