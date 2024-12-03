import Testing

@testable import Advent2021

@Test
func day14() async throws {
    let day = try await Year2021().day(for: 14)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 3230)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 3_542_388_214_529)
}

@Test
func day14_simpleProblem1() throws {
    let input = """
        NNCB

        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
        """

    let formula = try #require(Day14.PolymerFormula(rawValue: input))
    let difference = formula.polymerize(count: 10)

    #expect(difference == 1588)
}
