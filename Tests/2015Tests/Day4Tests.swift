//
//  Day4Tests.swift
//
//
//  Created by Aaron Sky on 11/16/21.
//

import Foundation
import XCTest
@testable import Advent2015

class Day4Tests: XCTestCase {
    func testProblems() async throws {
        let input = try await Year2015().input(for: 4)
        let _ = try Day4(input)
//        let day = try Day4(input)
//        XCTAssertEqual(Int(await day.partOne()), 346386)
//        XCTAssertEqual(Int(await day.partTwo()), 9958218)
    }
}
