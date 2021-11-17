//
//  Day8Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day8Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2015().input(for: 8)
        let day = try Day8(input)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1333)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 2046)
    }
}
