import Foundation
import XCTest

@testable import Advent2021

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 1)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1692)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1724)
    }
}
