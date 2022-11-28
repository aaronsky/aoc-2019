import Foundation
import XCTest

@testable import Advent2021

class Day7Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 7)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 328187)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 91_257_582)
    }
}
