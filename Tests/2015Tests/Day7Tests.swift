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
    func testProblems() async throws {
        let input = try await Year2015().input(for: 7)
        let day = try Day7(input)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 956)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 40149)
    }
}
