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
        let day = try await Year2015().day(for:  5)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 255)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 55)
    }
}
