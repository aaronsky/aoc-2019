import Testing

@testable import Advent2022

@Test
func day13() async throws {
    let day = try await Year2022().day(for: 13)
    let partOne = await day.partOne()
    #expect(partOne == "5720")
    let partTwo = await day.partTwo()
    #expect(partTwo == "23504")
}
