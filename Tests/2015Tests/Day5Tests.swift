import Testing

@testable import Advent2015

@Test
func day5() async throws {
    let day = try await Year2015().day(for: 5)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 255)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 55)
}
