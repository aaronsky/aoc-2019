import Foundation
import XCTest

@testable import Advent2021

class Day21Tests: XCTestCase {
    func testProblems() async throws {
        let day = try await Year2021().day(for: 21)
        let partOne = await day.partOne()
        XCTAssertEqual(Int(partOne), 571032)
        let partTwo = await day.partTwo()
        XCTAssertEqual(Int(partTwo), 49975322685009)
    }

    func testSimpleProblem1() {
        var game = Day21.DiceGame(startPlayerOneAt: 4, startPlayerTwoAt: 8)
        let score = game.playDeterministically()
        XCTAssertEqual(score, 739785)
    }

    func testSimpleProblem2() {
        let game = Day21.DiceGame(startPlayerOneAt: 4, startPlayerTwoAt: 8)
        let universes = game.playNonDeterministically()
        XCTAssertEqual(universes, 444356092776315)
    }
}
