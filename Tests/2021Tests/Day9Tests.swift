import Foundation
import XCTest

@testable import Advent2021

class Day9Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 9)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 577)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 1_069_200)
    }

    func testSimpleProblem1() throws {
        let example = """
            2199943210
            3987894921
            9856789892
            8767896789
            9899965678
            """
        let heightMap = try XCTUnwrap(Day9.HeightMap(rawValue: example))
        let lowPoints = heightMap.findLowPoints()
        XCTAssertEqual(lowPoints.count, 4)
        let riskLevel = try lowPoints.sum {
            (try XCTUnwrap(heightMap.heights[$0.0, $0.1])) + 1
        }
        XCTAssertEqual(riskLevel, 15)
    }
}
