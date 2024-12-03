import Testing

@testable import Advent2022

@Test
func day25() async throws {
    let day = try await Year2022().day(for: 25)
    let partOne = await day.partOne()
    #expect(partOne == "")
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}
