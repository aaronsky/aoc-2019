//
//  Day4Tests.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day4Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 4)
        let problem = await day.partOne()
        XCTAssertEqual(Int(problem), 1196)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }

    func testSimpleProgram1() {
        let range = Day4.PasswordRange(start: 112233, end: 112233)
        XCTAssertTrue(range.isValid(112233))
    }

    func testSimpleProgram2() {
        let range = Day4.PasswordRange(start: 123444, end: 123444)
        XCTAssertFalse(range.isValid(123444))
    }

    func testSimpleProgram3() {
        let range = Day4.PasswordRange(start: 111122, end: 111122)
        XCTAssertTrue(range.isValid(111122))
    }

}
