//
//  Day2Tests.swift
//
//
//  Created by Aaron Sky on 12/1/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day2Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 2)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1746616)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1741971043)
    }
}
