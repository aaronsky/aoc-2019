//
//  Day18Tests.swift
//
//
//  Created by Aaron Sky on 12/18/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day18Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 18)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 4132)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 4685)
    }
}
