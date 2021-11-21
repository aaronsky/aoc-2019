//
//  Day2Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day2Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 2)
        let problem = await day.partOne()
        XCTAssertTrue(problem.hasPrefix("[12490719,"))
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }

    func testSimpleProgram1() {
        var program = Intcode(program: [1, 0, 0, 0, 99])
        _ = program.run()
        XCTAssertEqual(program.debugDescription, "[2, 0, 0, 0, 99, 0, 0, 0, 0, 0]")
    }

    func testSimpleProgram2() {
        var program = Intcode(program: [2, 3, 0, 3, 99])
        _ = program.run()
        XCTAssertEqual(program.debugDescription, "[2, 3, 0, 6, 99, 0, 0, 0, 0, 0]")
    }

    func testSimpleProgram3() {
        var program = Intcode(program: [2, 4, 4, 5, 99, 0])
        _ = program.run()
        XCTAssertEqual(program.debugDescription, "[2, 4, 4, 5, 99, 9801, 0, 0, 0, 0, 0, 0]")
    }

    func testSimpleProgram4() {
        var program = Intcode(program: [1, 1, 1, 4, 99, 5, 6, 0, 99])
        _ = program.run()
        XCTAssertEqual(program.debugDescription, "[30, 1, 1, 4, 2, 5, 6, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0]")
    }
}
