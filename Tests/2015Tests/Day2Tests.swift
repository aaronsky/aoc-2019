import Foundation
import XCTest

@testable import Advent2015

class Day2Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2015().day(for: 2)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1_598_415)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 3_812_909)
    }
}
