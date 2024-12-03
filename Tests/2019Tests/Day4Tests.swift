import Testing

@testable import Advent2019

@Test
func day4() async throws {
    let day = try await Year2019().day(for: 4)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 1196)
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}

@Test
func day4_simpleProgram1() async throws {
    let range = Day4.PasswordRange(start: 112233, end: 112233)
    #expect(range.isValid(112233))
}

@Test
func day4_simpleProgram2() async throws {
    let range = Day4.PasswordRange(start: 123444, end: 123444)
    #expect(!range.isValid(123444))
}

@Test
func day4_simpleProgram3() async throws {
    let range = Day4.PasswordRange(start: 111122, end: 111122)
    #expect(range.isValid(111122))
}
