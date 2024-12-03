import Testing

@testable import Advent2019

@Test
func day1() async throws {
    let day = try await Year2019().day(for: 1)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 4_892_166)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}
