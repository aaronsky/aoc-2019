//
//  Day1Tests.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2020

class Day1Tests: XCTestCase {
    func testProblems() throws {
        let input = try Year2020().input(for: 1)
        let day = try Day1(input)
        XCTAssertEqual(day.fixExpenseReportDoubles(), 32064)
        XCTAssertEqual(day.fixExpenseReportTriples(), 193598720)
    }
}
