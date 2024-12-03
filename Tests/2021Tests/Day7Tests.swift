import Testing

@testable import Advent2021

@Test
func day7() async throws {
    let day = try await Year2021().day(for: 7)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 328187)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 91_257_582)
}
