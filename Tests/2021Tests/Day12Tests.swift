import Foundation
import XCTest

@testable import Advent2021

class Day12Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 12)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 4186)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 92111)
    }
}
