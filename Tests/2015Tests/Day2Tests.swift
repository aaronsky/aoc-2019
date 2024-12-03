import Testing

@testable import Advent2015

@Test
func day2() async throws {
    let day = try await Year2015().day(for: 2)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1_598_415)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 3_812_909)
}
