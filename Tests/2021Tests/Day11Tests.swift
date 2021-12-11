//
//  Day11Tests.swift
//
//
//  Created by Aaron Sky on 12/9/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day11Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 11)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1627)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 329)
    }

    func testSimpleProblem1() throws {
        let input = """
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """
        var matrix = try XCTUnwrap(Day11.Matrix(rawValue: input))
        var flashes = 0
        for _ in 0..<10 {
            flashes += matrix.step()
        }
        XCTAssertEqual(flashes, 204)
        for _ in 10..<100 {
            flashes += matrix.step()
        }
        XCTAssertEqual(flashes, 1656)
    }
}
