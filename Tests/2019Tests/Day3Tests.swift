import Foundation
import XCTest

@testable import Advent2019

class Day3Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 3)
        let problem = await day.partOne()
        XCTAssertEqual(Int(problem), 5672)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }
}
