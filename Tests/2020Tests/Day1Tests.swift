import Testing

@testable import Advent2020

@Test
func day1() async throws {
    let day = try await Year2020().day(for: 1)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 32064)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 193_598_720)
}
