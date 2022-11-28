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
import Advent2022

@main
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
        Year2022.year: Year2022(),
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

        try await withThrowingTaskGroup(of: Void.self) { group in
            for dayNumber in days {
                try await runDay(dayNumber, year: year, group: &group)
            }
        }
    }

    func runDay<E: Swift.Error>(_ dayNumber: Int, year: Year, group: inout ThrowingTaskGroup<Void, E>) async throws {
        let day = try await year.day(for: dayNumber)

        group.addTask {
            await runDayProblem(1, day: day, dayNumber: dayNumber)
        }

        group.addTask {
            await runDayProblem(2, day: day, dayNumber: dayNumber)
        }
    }

    func runDayProblem(_ problemNumber: Int, day: Day, dayNumber: Int) async {
        let start = CFAbsoluteTimeGetCurrent()

        let problem: () async -> String
        switch problemNumber {
        case 1:
            problem = day.partOne
        case 2:
            problem = day.partTwo
        default:
            fatalError("Days like \(dayNumber) don't have any other problem numbers than 1 or 2")
        }

        let answer = await problem()

        guard !answer.isEmpty else {
            return
        }

        printProblemOutput(year: self.year,
                           day: dayNumber,
                           problemNumber: problemNumber,
                           answer: answer,
                           elapsedTime: CFAbsoluteTimeGetCurrent() - start)
    }

    func printProblemOutput(year: Int, day: Int, problemNumber: Int, answer: String, elapsedTime: TimeInterval) {
        print("\(year) / \(day) - #\(problemNumber):", answer, "(\(String(format: "%.2f", elapsedTime))s)")
    }
}
