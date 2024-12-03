import Testing

@testable import Advent2022

@Test
func day9() async throws {
    let day = try await Year2022().day(for: 9)
    let partOne = await day.partOne()
    #expect(partOne == "6181")
    let partTwo = await day.partTwo()
    #expect(partTwo == "2386")
}
