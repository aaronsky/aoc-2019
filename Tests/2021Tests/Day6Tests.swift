import Testing

@testable import Advent2021

@Test
func day6() async throws {
    let day = try await Year2021().day(for: 6)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 393019)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_757_714_216_975)
}

@Test
func day6_smallSample1() {
    let day = Day6(fish: [3, 4, 3, 1, 2])
    #expect(day.totalFishAfter(days: 80) == 5934)
}

@Test
func day6_smallSample2() {
    let day = Day6(fish: [3, 4, 3, 1, 2])
    #expect(day.totalFishAfter(days: 256) == 26_984_457_539)
}
