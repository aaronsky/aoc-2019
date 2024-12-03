import Testing

@testable import Advent2016

@Test
func day1() async throws {
    let day = try await Year2016().day(for: 1)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 246)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 124)
}
