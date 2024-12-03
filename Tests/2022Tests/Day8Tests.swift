import Testing

@testable import Advent2022

@Test
func day8() async throws {
    let day = try await Year2022().day(for: 8)
    let partOne = await day.partOne()
    #expect(partOne == "1859")
    let partTwo = await day.partTwo()
    #expect(partTwo == "332640")
}
