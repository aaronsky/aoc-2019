import Testing

@testable import Advent2021

@Test
func day18() async throws {
    let day = try await Year2021().day(for: 18)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 4132)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 4685)
}
