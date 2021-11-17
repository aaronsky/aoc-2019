//
//  Day7Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day7Tests: XCTestCase {
    func testProblems() throws {
        let input = try Year2015().input(for: 7)
        let day = try Day7(input)
        XCTAssertEqual(Int(day.partOne()), 956)
        XCTAssertEqual(Int(day.partTwo()), 40149)
    }
}
