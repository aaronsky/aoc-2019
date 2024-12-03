import Testing

@testable import Advent2021

@Test
func day17() async throws {
    let day = try await Year2021().day(for: 17)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 12561)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 3785)
}
