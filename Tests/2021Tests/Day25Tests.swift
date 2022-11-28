import Foundation
import XCTest

@testable import Advent2021

class Day25Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 25)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 441)
        let nothing = await day.partTwo()
        XCTAssertEqual(nothing, "")
    }

    func testSimpleProblem1() throws {
        let input = """
        v...>>.vv>
        .vv>>.vv..
        >>.>v>...v
        >>v>>.>.v.
        v>v.vv.v..
        >.>>..v...
        .vv..>.>v.
        v.v..>>v.v
        ....v..v.>
        """
        var floor = try XCTUnwrap(Day25.Seafloor(rawValue: input))
        let count = floor.stepUntilStable()
        XCTAssertEqual(count, 58)
    }
}
