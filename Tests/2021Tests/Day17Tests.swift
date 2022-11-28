import Foundation
import XCTest

@testable import Advent2021

class Day17Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 17)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 12561)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 3785)
    }
}
