import Foundation
import XCTest

@testable import Advent2015

class Day8Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2015().day(for: 8)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 1333)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 2046)
    }
}
