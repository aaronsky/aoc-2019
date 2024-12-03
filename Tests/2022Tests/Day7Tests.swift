import Testing

@testable import Advent2022

@Test
func day7() async throws {
    let day = try await Year2022().day(for: 7)
    let partOne = await day.partOne()
    #expect(partOne == "1334506")
    let partTwo = await day.partTwo()
    #expect(partTwo == "7421137")
}
