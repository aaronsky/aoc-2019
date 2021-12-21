//
//  Day1.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Algorithms
import Base

struct Day1: Day {
    var nums: [Int]

    init(_ input: Input) throws {
        nums = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        "\(fixExpenseReportDoubles())"
    }

    func partTwo() async -> String {
        "\(fixExpenseReportTriples())"
    }

    /// Returns the product of the values where a combination of doubles equals 2020.
    func fixExpenseReportDoubles() -> Int {
        var num1 = 0
        var num2 = 0

        for c in nums.combinations(ofCount: 2) {
            let (one, two) = (c[0], c[1])
            if one + two == 2020 {
                (num1, num2) = (one, two)
            }
        }

        return num1 * num2
    }

    /// Returns the product of the values where a combination of triples equals 2020.
    func fixExpenseReportTriples() -> Int {
        var num1 = 0
        var num2 = 0
        var num3 = 0

        for c in nums.combinations(ofCount: 3) {
            let (one, two, three) = (c[0], c[1], c[2])
            if one + two + three == 2020 {
                (num1, num2, num3) = (one, two, three)
            }
        }

        return num1 * num2 * num3
    }
}
