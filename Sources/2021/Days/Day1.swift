//
//  Day1.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Algorithms
import Base

struct Day1: Day {
    var depths: [Int]

    init(_ input: Input) throws {
        depths = input.decodeMany(separatedBy: "\n", transform: Int.init)
    }

    func partOne() async -> String {
        var lastDepth: Int?
        var increases: Int = 0

        for depth in depths {
            if let last = lastDepth, depth > last {
                increases += 1
            }
            lastDepth = depth
        }

        return "\(increases)"
    }

    func partTwo() async -> String {
        var lastSum: Int? = nil
        var increases: Int = 0

        for window in depths.windows(ofCount: 3) {
            let sum = window.reduce(0, +)
            if let lastSum = lastSum, sum > lastSum {
                increases += 1
            }
            lastSum = sum
        }

        return "\(increases)"
    }
}
