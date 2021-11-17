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
    var days: [Int] = []

    public init() {}

    public func run() throws {
        guard let year = AOC.allYears[self.year] else {
            throw Error.unknownYear(self.year)
        }

        let daysToRun: [Int: Day.Type]
        if days.isEmpty {
            daysToRun = year.days
        } else {
            daysToRun = try Dictionary(uniqueKeysWithValues: days.map {
                guard let dayType = year.days[$0] else {
                    throw Error.unknownDayInYear(day: $0, year: self.year)
                }
                return ($0, dayType)
            })
        }

        Task { // this isn't working right
            try await withThrowingTaskGroup(of: Void.self) { group in
                for (dayNum, dayType) in daysToRun {
                    group.addTask {
                        return try await runDay(dayType, dayNum, year: year)
                    }
                }

                try await group.waitForAll()
            }
        }
    }

    private func runDay(_ dayType: Day.Type, _ dayNumber: Int, year: Year) async throws {
        let input = try await year.input(for: dayNumber)
        let day = try dayType.init(input)
        print("Day \(dayNumber) \(type(of: year).year):", day)
    }
}
