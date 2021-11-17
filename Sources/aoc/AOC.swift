//
//  AOC.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import ArgumentParser
import Base
import Advent2015
import Advent2016
import Advent2017
import Advent2018
import Advent2019
import Advent2020
import Advent2021

@main
public struct AOC: ParsableCommand {
    enum Error: Swift.Error {
        case unknownYear(Int)
        case unknownDayInYear(day: Int, year: Int)
    }
    static let allYears: [Int: Year] = [
        Year2015.year: Year2015(),
        Year2016.year: Year2016(),
        Year2017.year: Year2017(),
        Year2018.year: Year2018(),
        Year2019.year: Year2019(),
        Year2020.year: Year2020(),
        Year2021.year: Year2021(),
    ]

    @Argument(help: "Year to run the problem for.")
    var year: Int

    @Argument(help: "Day in the year to run the problem for.")
    var day: Int?

    public init() {}

    public func run() throws {
        guard let year = AOC.allYears[self.year] else {
            throw Error.unknownYear(self.year)
        }

        if let dayNum = self.day {
            guard let dayType = year.days[dayNum] else {
                throw Error.unknownDayInYear(day: dayNum, year: self.year)
            }
            try runDay(dayType, dayNum, year: year)
        } else {
            for (dayNum, dayType) in year.days {
                try runDay(dayType, dayNum, year: year)
            }
        }
    }

    private func runDay(_ dayType: Day.Type, _ dayNumber: Int, year: Year) throws {
        let input = try year.input(for: dayNumber)
        let day = try dayType.init(input)
        print("Day \(dayNumber) \(type(of: year).year):", day)
    }
}
