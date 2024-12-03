import Testing

@testable import Advent2022

@Test
func day10() async throws {
    let day = try await Year2022().day(for: 10)
    let partOne = await day.partOne()
    #expect(partOne == "11820")
    let partTwo = await day.partTwo()
    #expect(partTwo == "EPJBRKAH")
}
