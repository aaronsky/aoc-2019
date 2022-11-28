import Foundation
import XCTest

@testable import Advent2019

class Day5Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 5)
        let problem = await day.partOne()
        XCTAssertEqual(Int(problem), 8805067)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }
}
