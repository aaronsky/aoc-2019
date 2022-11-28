import Foundation
import XCTest

@testable import Advent2016

class Day3Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2016().day(for: 3)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 917)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1649)
    }
}
