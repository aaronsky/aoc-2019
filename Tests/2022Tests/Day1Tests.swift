import Testing

@testable import Advent2022

@Test
func day1() async throws {
    let day = try await Year2022().day(for: 1)
    let partOne = await day.partOne()
    #expect(partOne == "65912")
    let partTwo = await day.partTwo()
    #expect(partTwo == "195625")
}
