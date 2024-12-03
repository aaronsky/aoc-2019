import Testing

@testable import Advent2015

@Test
func day6() async throws {
    let day = try await Year2015().day(for: 6)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 569999)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 17_836_115)
}
