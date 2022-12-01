import Foundation
import XCTest

@testable import Advent2022

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 1)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "65912")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "195625")
    }
}
