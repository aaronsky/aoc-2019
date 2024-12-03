import Testing

@testable import Advent2021

@Test
func day15() async throws {
    let day = try await Year2021().day(for: 15)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 458)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 2800)
}
