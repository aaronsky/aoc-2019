import Testing

@testable import Advent2021

@Test
func day4() async throws {
    let day = try await Year2021().day(for: 4)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 60368)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 17435)
}
