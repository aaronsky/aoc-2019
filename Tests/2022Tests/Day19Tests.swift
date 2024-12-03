import Testing

@testable import Advent2022

@Test
func day19() async throws {
    let day = try await Year2022().day(for: 19)
    let partOne = await day.partOne()
    #expect(partOne == "")
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}
