//
//  Day23Tests.swift
//
//
//  Created by Aaron Sky on 12/23/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day23Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 23)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), nil)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), nil)
    }
}
