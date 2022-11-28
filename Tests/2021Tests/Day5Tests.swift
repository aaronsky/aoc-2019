import Foundation
import XCTest

@testable import Advent2021

class Day5Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 5)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 5294)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 21698)
    }

    func testSimpleProgramOrthogonal() async throws {
        let vents: [Day5.Vent] = [
            .init(startX: 0, startY: 9, endX: 5, endY: 9),
            .init(startX: 8, startY: 0, endX: 0, endY: 8),
            .init(startX: 9, startY: 4, endX: 3, endY: 4),
            .init(startX: 2, startY: 2, endX: 2, endY: 1),
            .init(startX: 7, startY: 0, endX: 7, endY: 4),
            .init(startX: 6, startY: 4, endX: 2, endY: 0),
            .init(startX: 0, startY: 9, endX: 2, endY: 9),
            .init(startX: 3, startY: 4, endX: 1, endY: 4),
            .init(startX: 0, startY: 0, endX: 8, endY: 8),
            .init(startX: 5, startY: 5, endX: 8, endY: 2),
        ]
        let count = Day5(vents: vents).countCoincidentPoints(in: vents.filter { $0.isHorizontal || $0.isVertical })
        XCTAssertEqual(count, 5)
    }

    func testSimpleProgramDiagonal() async throws {
        let vents: [Day5.Vent] = [
            .init(startX: 0, startY: 9, endX: 5, endY: 9),
            .init(startX: 8, startY: 0, endX: 0, endY: 8),
            .init(startX: 9, startY: 4, endX: 3, endY: 4),
            .init(startX: 2, startY: 2, endX: 2, endY: 1),
            .init(startX: 7, startY: 0, endX: 7, endY: 4),
            .init(startX: 6, startY: 4, endX: 2, endY: 0),
            .init(startX: 0, startY: 9, endX: 2, endY: 9),
            .init(startX: 3, startY: 4, endX: 1, endY: 4),
            .init(startX: 0, startY: 0, endX: 8, endY: 8),
            .init(startX: 5, startY: 5, endX: 8, endY: 2),
        ]
        let count = Day5(vents: vents).countCoincidentPoints(in: vents)
        XCTAssertEqual(count, 12)
    }
}
