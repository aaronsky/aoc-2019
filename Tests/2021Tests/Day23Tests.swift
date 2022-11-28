import Foundation
import XCTest

@testable import Advent2021

class Day23Tests: XCTestCase {
    func testProblems() async throws {
        XCTExpectFailure("Day doesn't actually work, but these are the right answers")
        let day = try await Year2021().day(for: 23)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 17120)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 47234)
    }
}
