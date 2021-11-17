//
//  Day6Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day6Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2015().input(for: 6)
        let _ = try Day6(input)
//        let day = try Day6(input)
//        XCTAssertEqual(Int(await day.partOne()), 2592)
//        XCTAssertEqual(Int(await day.partTwo()), 2360)
    }
}
