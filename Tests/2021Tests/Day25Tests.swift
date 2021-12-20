//
//  Day25Tests.swift
//
//
//  Created by Aaron Sky on 12/25/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day25Tests: XCTestCase {
    func testProblems() async throws {
        XCTExpectFailure("Day has not yet occurred")
        let day = try await Year2021().day(for: 25)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 0)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 0)
    }
}
