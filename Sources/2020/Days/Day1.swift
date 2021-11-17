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
        nums = try input.decodeMany(separatedBy: "\n")
    }

    func partOne() -> String {
        "\(fixExpenseReportDoubles())"
    }

    func partTwo() -> String {
        "\(fixExpenseReportTriples())"
    }

    /// Returns the product of the values where a combination of doubles equals 2020.
    func fixExpenseReportDoubles() -> Int {
        var num1 = 0
        var num2 = 0

        for c in nums.combinations(ofCount: 2) {
            if c[0] + c[1] == 2020 {
                num1 = c[0]
                num2 = c[1]
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
            if c[0] + c[1] + c[2] == 2020 {
                num1 = c[0]
                num2 = c[1]
                num3 = c[2]
            }
        }

        return num1 * num2 * num3
    }
}
