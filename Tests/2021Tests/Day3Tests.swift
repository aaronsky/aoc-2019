import Testing

@testable import Advent2021

@Test
func day3() async throws {
    let day = try await Year2021().day(for: 3)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 3_912_944)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 4_996_233)
}
