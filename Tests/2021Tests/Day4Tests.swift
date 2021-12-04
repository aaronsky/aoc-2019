//
//  Day4Tests.swift
//
//
//  Created by Aaron Sky on 12/2/21.
//

import Foundation
import XCTest
@testable import Advent2021

class Day4Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 4)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 60368)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 17435)
    }
}
