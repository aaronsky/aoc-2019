import Testing

@testable import Advent2019

@Test
func day2() async throws {
    let day = try await Year2019().day(for: 2)
    let partOne = await day.partOne()
    #expect(partOne.hasPrefix("[12490719,"))
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}

@Test
func day2_simpleProgram1() async throws {
    var program = Intcode(program: [1, 0, 0, 0, 99])
    _ = program.run()
    #expect(program.debugDescription == "[2, 0, 0, 0, 99, 0, 0, 0, 0, 0]")
}

@Test
func day2_simpleProgram2() async throws {
    var program = Intcode(program: [2, 3, 0, 3, 99])
    _ = program.run()
    #expect(program.debugDescription == "[2, 3, 0, 6, 99, 0, 0, 0, 0, 0]")
}

@Test
func day2_simpleProgram3() async throws {
    var program = Intcode(program: [2, 4, 4, 5, 99, 0])
    _ = program.run()
    #expect(program.debugDescription == "[2, 4, 4, 5, 99, 9801, 0, 0, 0, 0, 0, 0]")
}

@Test
func day2_simpleProgram4() async throws {
    var program = Intcode(program: [1, 1, 1, 4, 99, 5, 6, 0, 99])
    _ = program.run()
    #expect(program.debugDescription == "[30, 1, 1, 4, 2, 5, 6, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0]")
}
