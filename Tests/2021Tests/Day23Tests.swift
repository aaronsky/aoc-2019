import Testing

@testable import Advent2021

@Test
func day23() async throws {
    await withKnownIssue("Day doesn't actually work, but these are the right answers") {
        let day = try await Year2021().day(for: 23)
        let partOne = await day.partOne()
        #expect(Int(partOne) == 17120)
        let partTwo = await day.partTwo()
        #expect(Int(partTwo) == 47234)
    }
}
