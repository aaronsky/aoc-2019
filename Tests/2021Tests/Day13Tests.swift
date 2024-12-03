import Testing

@testable import Advent2021

@Test
func day13() async throws {
    let day = try await Year2021().day(for: 13)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 735)
    let partTwo = await day.partTwo()
    #expect(partTwo == "UFRZKAUZ")
}
