import Testing

@testable import Advent2021

@Test
func day24() async throws {
    let day = try await Year2021().day(for: 24)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 79_997_391_969_649)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 16_931_171_414_113)
}
