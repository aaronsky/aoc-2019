import Testing

@testable import Advent2021

@Test
func day16() async throws {
    let day = try await Year2021().day(for: 16)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 953)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 246_225_449_979)
}
