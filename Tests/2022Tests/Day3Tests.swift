import Testing

@testable import Advent2022

@Test
func day3() async throws {
    let day = try await Year2022().day(for: 3)
    let partOne = await day.partOne()
    #expect(partOne == "8139")
    let partTwo = await day.partTwo()
    #expect(partTwo == "2668")
}
