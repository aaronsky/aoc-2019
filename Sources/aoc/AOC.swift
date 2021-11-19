//
//  AOC.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import ArgumentParser
import Base
import Foundation
import Advent2015
import Advent2016
import Advent2017
import Advent2018
import Advent2019
import Advent2020
import Advent2021

/// This is necessary while swift-argument-parser does not support async out of the box
protocol AsyncParsableCommand: ParsableCommand {
    mutating func run() async throws
}

extension AsyncParsableCommand {
    static func main(_ arguments: [String]?) async {
        do {
            var command = try parseAsRoot(arguments)
            if var asyncCommand = command as? AsyncParsableCommand {
                try await asyncCommand.run()
            } else {
                try command.run()
            }
        } catch {
            exit(withError: error)
        }
    }
}

@main
struct Application {
    static func main() async {
        await AOC.main(nil)
    }
}

struct AOC: AsyncParsableCommand {
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

    func run() async throws {
        guard let year = AOC.allYears[self.year] else {
            throw Error.unknownYear(self.year)
        }

        let days: [Int]
        if self.days.isEmpty {
            days = Array(year.days.keys)
        } else {
            days = self.days
        }

        try await withThrowingTaskGroup(of: Void.self) { group in
            for day in days {
                group.addTask {
                    let dayType = try await year.day(for: day)
                    let (partOne, partTwo) = await (dayType.partOne(), dayType.partTwo())
                    print("""
----------
Day \(day) \(type(of: year).year)
Part One: \(partOne)\(partTwo.isEmpty ? "" : "\nPart Two: \(partTwo)")
""")
                }
            }

            try await group.waitForAll()
            print("----------")
        }
    }
}
