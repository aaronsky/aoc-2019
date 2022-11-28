import Foundation
import XCTest

@testable import Advent2016

class Day2Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2016().day(for: 2)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "56855")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "B3C27")
    }
}
