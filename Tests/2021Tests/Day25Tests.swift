import Testing

@testable import Advent2021

@Test
func day25() async throws {
    let day = try await Year2021().day(for: 25)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 441)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}

@Test
func day25_simpleProgram1() async throws {
    let input = """
        v...>>.vv>
        .vv>>.vv..
        >>.>v>...v
        >>v>>.>.v.
        v>v.vv.v..
        >.>>..v...
        .vv..>.>v.
        v.v..>>v.v
        ....v..v.>
        """
    var floor = try #require(Day25.Seafloor(rawValue: input))
    let count = floor.stepUntilStable()
    #expect(count == 58)
}
