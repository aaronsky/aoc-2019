import Foundation
import XCTest

@testable import Advent2021

class Day24Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 24)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 79997391969649)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 16931171414113)
    }
}
