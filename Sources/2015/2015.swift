//
//  2015.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import Base

public struct Year2015: Year {
    public static let year = 2015

    public let days: [Int: Day.Type] = [
        1: Day1.self,
        2: Day2.self,
        3: Day3.self,
        4: Day4.self,
        5: Day5.self,
        6: Day6.self,
        7: Day7.self,
        8: Day8.self,
//        9: Day9.self,
//        10: Day10.self,
//        11: Day11.self,
//        12: Day12.self,
//        13: Day13.self,
//        14: Day14.self,
//        15: Day15.self,
//        16: Day16.self,
//        17: Day17.self,
//        18: Day18.self,
//        19: Day19.self,
//        20: Day20.self,
//        21: Day21.self,
//        22: Day22.self,
//        23: Day23.self,
//        24: Day24.self,
//        25: Day25.self,
    ]

    public init() {}

    public func input(for day: Int) async throws -> Input {
        try await Input(day: day, in: Bundle.module)
    }
}
