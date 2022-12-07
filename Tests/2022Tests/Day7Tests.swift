import Foundation
import XCTest

@testable import Advent2022

class Day7Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 7)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "1334506")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "7421137")
    }
}
