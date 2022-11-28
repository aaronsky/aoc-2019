import Foundation
import XCTest

@testable import Advent2020

class Day1Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2020().day(for: 1)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 32064)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 193598720)
    }
}
