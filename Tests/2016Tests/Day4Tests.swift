import Testing

@testable import Advent2016

@Test
func day4() async throws {
    let day = try await Year2016().day(for: 4)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 0)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 0)
}

@Test
func day4_simpleProgram() throws {
    let room1 = try #require(Day4.Room(rawValue: "aaaaa-bbb-z-y-x-123[abxyz]"))
    #expect(room1.isReal)

    let room2 = try #require(Day4.Room(rawValue: "a-b-c-d-e-f-g-h-987[abcde]"))
    #expect(room2.isReal)

    let room3 = try #require(Day4.Room(rawValue: "not-a-real-room-404[oarel]"))
    #expect(room3.isReal)

    let room4 = try #require(Day4.Room(rawValue: "totally-real-room-200[decoy]"))
    #expect(room4.isReal)
}
