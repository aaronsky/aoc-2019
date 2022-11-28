import Foundation
import XCTest

@testable import Advent2019

class Day11Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 11)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 2211)
        let partTwo = await day.partTwo()
        XCTAssertEqual(partTwo, "EFCKUEGC")
    }
}
