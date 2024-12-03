import Testing

@testable import Advent2022

@Test
func day2() async throws {
    let day = try await Year2022().day(for: 2)
    let partOne = await day.partOne()
    #expect(partOne == "12586")
    let partTwo = await day.partTwo()
    #expect(partTwo == "13193")
}
