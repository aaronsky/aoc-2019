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
    func testProblems() throws {
        let input = try Year2015().input(for: 8)
        let day = try Day8(input)
        XCTAssertEqual(Int(day.partOne()), 1333)
        XCTAssertEqual(Int(day.partTwo()), 2046)
    }
}
