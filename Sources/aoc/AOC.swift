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
            days = year.days.keys.sorted()
        } else {
            days = self.days
        }

        @Sendable func printProblemOutput(year: Int, day: Int, problemNumber: Int, answer: String, elapsedTime: TimeInterval) {
            print("\(year) / \(day) - #\(problemNumber):", answer, "(\(String(format: "%.2f", elapsedTime))s)")
        }

        try await withThrowingTaskGroup(of: Void.self) { group in
            for dayNumber in days {
                let day = try await year.day(for: dayNumber)

                group.addTask {
                    let start = CFAbsoluteTimeGetCurrent()
                    let answer = await day.partOne()
                    guard !answer.isEmpty else {
                        return
                    }
                    printProblemOutput(year: self.year,
                                       day: dayNumber,
                                       problemNumber: 1,
                                       answer: answer,
                                       elapsedTime: CFAbsoluteTimeGetCurrent() - start)
                }

                group.addTask {
                    let start = CFAbsoluteTimeGetCurrent()
                    let answer = await day.partTwo()
                    guard !answer.isEmpty else {
                        return
                    }
                    printProblemOutput(year: self.year,
                                       day: dayNumber,
                                       problemNumber: 2,
                                       answer: answer,
                                       elapsedTime: CFAbsoluteTimeGetCurrent() - start)
                }
            }
        }
    }
}
