import Foundation
import XCTest

@testable import Advent2021

class Day10Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 10)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 166191)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1_152_088_313)
    }
}
