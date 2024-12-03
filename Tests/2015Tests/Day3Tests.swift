import Testing

@testable import Advent2015

@Test
func day3() async throws {
    let day = try await Year2015().day(for: 3)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 2592)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 2360)
}
