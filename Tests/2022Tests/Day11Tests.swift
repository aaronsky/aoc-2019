import Foundation
import XCTest

@testable import Advent2022

class Day11Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 11)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "")
    }
}
