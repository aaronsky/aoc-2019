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
    func testProblems() throws {
        let input = try Year2015().input(for: 1)
        let day = try Day1(input)
        XCTAssertEqual(Int(day.partOne()), 232)
        XCTAssertEqual(Int(day.partTwo()), 1783)
    }
}
