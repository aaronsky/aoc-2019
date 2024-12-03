import Testing

@testable import Advent2022

@Test
func day6() async throws {
    let day = try await Year2022().day(for: 6)
    let partOne = await day.partOne()
    #expect(partOne == "1655")
    let partTwo = await day.partTwo()
    #expect(partTwo == "2665")
}
