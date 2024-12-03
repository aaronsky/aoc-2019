import Testing

@testable import Advent2021

@Test
func day2() async throws {
    let day = try await Year2021().day(for: 2)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1_746_616)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_741_971_043)
}
