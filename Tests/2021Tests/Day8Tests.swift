import Foundation
import XCTest

@testable import Advent2021

class Day8Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 8)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 514)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1012272)
    }
}
