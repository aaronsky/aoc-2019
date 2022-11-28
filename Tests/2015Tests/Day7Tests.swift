import Foundation
import XCTest

@testable import Advent2015

class Day7Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2015().day(for: 7)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 956)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 40149)
    }
}
