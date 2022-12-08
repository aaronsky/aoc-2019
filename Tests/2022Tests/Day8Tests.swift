import Foundation
import XCTest

@testable import Advent2022

class Day8Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 8)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "1859")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "332640")
    }
}
