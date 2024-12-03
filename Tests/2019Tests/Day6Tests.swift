import Testing

@testable import Advent2019

@Test
func day6() async throws {
    let day = try await Year2019().day(for: 6)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 496)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}

@Test
func day6_simpleProgram1() async throws {
    let input = """
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        """
    let map = try #require(Day6.OrbitMap(rawValue: input))
    #expect(map.map.count == 42)
}

@Test
func day6_simpleProgram2() async throws {
    let input = """
        COM)B
        B)C
        C)D
        D)E
        E)F
        B)G
        G)H
        D)I
        E)J
        J)K
        K)L
        K)YOU
        I)SAN
        """
    let map = try #require(Day6.OrbitMap(rawValue: input))
    #expect(map.numberOfOrbitalTransfers(from: .you, to: .santa) == 4)
}
