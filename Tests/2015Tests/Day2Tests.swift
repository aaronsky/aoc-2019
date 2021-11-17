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
    func testProblems() throws {
        let input = try Year2015().input(for: 2)
        let day = try Day2(input)
        XCTAssertEqual(Int(day.partOne()), 1598415)
        XCTAssertEqual(Int(day.partTwo()), 3812909)
    }
}
