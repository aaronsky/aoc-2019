import Foundation
import XCTest

@testable import Advent2021

class Day15Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 15)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 458)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 2800)
    }
}
