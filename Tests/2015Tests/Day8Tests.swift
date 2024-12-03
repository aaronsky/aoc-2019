import Testing

@testable import Advent2015

@Test
func day8() async throws {
    let day = try await Year2015().day(for: 8)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1333)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 2046)
}
