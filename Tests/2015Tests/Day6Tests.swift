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
    func testProblems() throws {
        let input = try Year2015().input(for: 6)
        let _ = try Day6(input)
//        let day = try Day6(input)
//        XCTAssertEqual(Int(day.partOne()), 2592)
//        XCTAssertEqual(Int(day.partTwo()), 2360)
    }
}
