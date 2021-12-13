//
//  Day13Tests.swift
//
//
//  Created by Aaron Sky on 12/13/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day13Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 13)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 735)
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "UFRZKAUZ")
    }
}
