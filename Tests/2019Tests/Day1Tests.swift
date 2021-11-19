//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 1)
        let problem = await day.partOne()
        XCTAssertEqual(Int(problem), 4892166)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }
}
