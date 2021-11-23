//
//  Day10Tests.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day10Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 10)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 280)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 706)
    }
}
