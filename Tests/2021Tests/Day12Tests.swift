import Testing

@testable import Advent2021

@Test
func day12() async throws {
    let day = try await Year2021().day(for: 12)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 4186)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 92111)
}
