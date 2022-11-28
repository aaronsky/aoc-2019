import Foundation
import XCTest

@testable import Advent2021

class Day6Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 6)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 393019)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1757714216975)
    }

    func testSmallSample1() {
        let day = Day6(fish: [3,4,3,1,2])
        XCTAssertEqual(day.totalFishAfter(days: 80), 5934)
    }

    func testSmallSample2() {
        let day = Day6(fish: [3,4,3,1,2])
        XCTAssertEqual(day.totalFishAfter(days: 256), 26984457539)
    }
}
