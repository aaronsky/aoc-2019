import Testing

@testable import Advent2015

@Test
func day1() async throws {
    let day = try await Year2015().day(for: 1)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 232)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1783)
}
