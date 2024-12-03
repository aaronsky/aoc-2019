import Testing

@testable import Advent2015

@Test
func day7() async throws {
    let day = try await Year2015().day(for: 7)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 956)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 40149)
}
