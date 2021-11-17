//
//  Day1Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2015().input(for: 1)
        let day = try Day1(input)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 232)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1783)
    }
}
