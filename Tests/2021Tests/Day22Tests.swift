//
//  Day22Tests.swift
//
//
//  Created by Aaron Sky on 12/22/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day22Tests: XCTestCase {
    func testProblems() async throws {
        XCTExpectFailure("Day has not yet occurred")
        let day = try await Year2021().day(for: 22)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 0)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 0)
    }
}
