import Testing

@testable import Advent2016

@Test
func day2() async throws {
    let day = try await Year2016().day(for: 2)
    let partOne = await day.partOne()
    #expect(partOne == "56855")
    let partTwo = await day.partTwo()
    #expect(partTwo == "B3C27")
}
