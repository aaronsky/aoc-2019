import Foundation
import XCTest

@testable import Advent2019

class Day8Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2019().day(for: 8)
        let problem = await day.partOne()
        XCTAssertEqual(
            problem,
            "100100110001100111101111010010100101001010000100001111010000100001110011100100101000010110100001000010010100101001010000100001001001100011101000011110"
        )
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }

    func testSimpleProgram1() {
        let pixels = "0222112222120000"
        let layers = [Day8.Layer](
            rawImage: Day8.RawImage(
                pixels: pixels,
                width: 2,
                height: 2
            )
        )
        let combined = Day8.Layer(combining: layers)
        XCTAssertEqual(combined.description, "0110")
    }
}
