import Foundation
import XCTest

@testable import Advent2022

class Day5Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 5)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "VJSFHWGFT")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "LCTQFBVZV")
    }
}
