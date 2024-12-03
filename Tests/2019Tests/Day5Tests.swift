import Testing

@testable import Advent2019

@Test
func day5() async throws {
    let day = try await Year2019().day(for: 5)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 8_805_067)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}
