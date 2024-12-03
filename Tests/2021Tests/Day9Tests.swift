import Testing

@testable import Advent2021

@Test
func day9() async throws {
    let day = try await Year2021().day(for: 9)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 577)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_069_200)
}

@Test
func day9_simpleProblem1() throws {
    let example = """
        2199943210
        3987894921
        9856789892
        8767896789
        9899965678
        """
    let heightMap = try #require(Day9.HeightMap(rawValue: example))
    let lowPoints = heightMap.findLowPoints()
    #expect(lowPoints.count == 4)
    let riskLevel = try lowPoints.sum {
        (try #require(heightMap.heights[$0.0, $0.1])) + 1
    }
    #expect(riskLevel == 15)
}
