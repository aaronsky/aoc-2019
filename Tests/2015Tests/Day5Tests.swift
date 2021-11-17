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
    func testProblems() async throws {
        let input = try await Year2015().input(for: 5)
        let _ = try Day5(input)
//        let day = try Day5(input)
//        XCTAssertEqual(Int(await day.partOne()), 2592)
//        XCTAssertEqual(Int(await day.partTwo()), 2360)
    }
}
