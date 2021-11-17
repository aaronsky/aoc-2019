//
//  Day2Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day2Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2015().input(for: 2)
        let day = try Day2(input)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1598415)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 3812909)
    }
}
