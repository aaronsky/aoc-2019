import Testing

@testable import Advent2021

@Test
func day11() async throws {
    let day = try await Year2021().day(for: 11)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1627)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 329)
}

@Test
func day11_simpleProblem1() throws {
    let input = """
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
        """
    var octopuses = try #require(Day11.Octopuses(rawValue: input))
    var flashes = 0
    for _ in 1...10 {
        flashes += octopuses.step()
    }
    #expect(flashes == 204)
    for _ in 11...100 {
        flashes += octopuses.step()
    }
    #expect(flashes == 1656)
}
