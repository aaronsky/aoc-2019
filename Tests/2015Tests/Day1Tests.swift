import Foundation
import XCTest

@testable import Advent2015

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2015().day(for: 1)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 232)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1783)
    }
}
