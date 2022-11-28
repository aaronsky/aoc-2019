import Foundation
import XCTest

@testable import Advent2021

class Day20Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 20)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 4917)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 16389)
    }
}
