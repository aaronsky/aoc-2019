//
//  Day21Tests.swift
//
//
//  Created by Aaron Sky on 12/21/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day21Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 21)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), nil)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), nil)
    }
}
