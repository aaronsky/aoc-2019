import Foundation
import XCTest

@testable import Advent2021

class Day19Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 19)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 353)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 10832)
    }
}
