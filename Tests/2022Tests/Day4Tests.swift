import Testing

@testable import Advent2022

@Test
func day4() async throws {
    let day = try await Year2022().day(for: 4)
    let partOne = await day.partOne()
    #expect(partOne == "413")
    let partTwo = await day.partTwo()
    #expect(partTwo == "806")
}
