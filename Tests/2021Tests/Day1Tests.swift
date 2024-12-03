import Testing

@testable import Advent2021

@Test
func day1() async throws {
    let day = try await Year2021().day(for: 1)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1692)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1724)
}
