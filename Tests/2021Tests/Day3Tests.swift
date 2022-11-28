import Foundation
import XCTest

@testable import Advent2021

class Day3Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 3)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 3_912_944)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 4_996_233)
    }
}
