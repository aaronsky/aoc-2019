import Testing

@testable import Advent2022

@Test
func day5() async throws {
    let day = try await Year2022().day(for: 5)
    let partOne = await day.partOne()
    #expect(partOne == "VJSFHWGFT")
    let partTwo = await day.partTwo()
    #expect(partTwo == "LCTQFBVZV")
}
