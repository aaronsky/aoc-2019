import Testing

@testable import Advent2021

@Test
func day8() async throws {
    let day = try await Year2021().day(for: 8)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 514)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_012_272)
}
