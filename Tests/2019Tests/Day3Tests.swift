import Testing

@testable import Advent2019

@Test
func day3() async throws {
    let day = try await Year2019().day(for: 3)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 5672)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}
