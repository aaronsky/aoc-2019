//
//  Day12Tests.swift
//
//
//  Created by Aaron Sky on 12/16/21.
//

import Foundation
import XCTest
@testable import Advent2019

class Day12Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 12)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 14907)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 467_081_194_429_464)
    }
}
