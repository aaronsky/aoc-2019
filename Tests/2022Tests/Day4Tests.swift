import Foundation
import XCTest

@testable import Advent2022

class Day4Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2022().day(for: 4)
        let partOne = await day.partOne()
        XCTAssertEqual(partOne, "413")
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "806")
    }
}
