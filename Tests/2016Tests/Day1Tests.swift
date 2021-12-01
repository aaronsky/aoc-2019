//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2016

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2016().day(for: 1)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 246)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 124)
    }
}
