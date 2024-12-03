import Testing

@testable import Advent2016

@Test
func day3() async throws {
    let day = try await Year2016().day(for: 3)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 917)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1649)
}
