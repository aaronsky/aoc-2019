//
//  Day5Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day5Tests: XCTestCase {
    func testProblems() throws {
        let input = try Year2015().input(for: 5)
        let _ = try Day5(input)
//        let day = try Day5(input)
//        XCTAssertEqual(Int(day.partOne()), 2592)
//        XCTAssertEqual(Int(day.partTwo()), 2360)
    }
}
