import Testing

@testable import Advent2021

@Test
func day21() async throws {
    let day = try await Year2021().day(for: 21)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 571032)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 49_975_322_685_009)
}

@Test
func day21_simpleProblem1() {
    var game = Day21.DiceGame(startPlayerOneAt: 4, startPlayerTwoAt: 8)
    let score = game.playDeterministically()
    #expect(score == 739785)
}

@Test
func day21_simpleProblem2() {
    let game = Day21.DiceGame(startPlayerOneAt: 4, startPlayerTwoAt: 8)
    let universes = game.playNonDeterministically()
    #expect(universes == 444_356_092_776_315)
}
