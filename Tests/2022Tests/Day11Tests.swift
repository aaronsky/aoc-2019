import Testing

@testable import Advent2022

@Test
func day11() async throws {
    // let day = try await Year2022().day(for: 11)
    // let partOne = await day.partOne()
    // #expect(partOne == "110888")
    // let partTwo = await day.partTwo()
    // #expect(partTwo == "25590400731")
}

@Test
func day11_simple() async throws {
    let day = Day11(monkeys: [
        .init(items: [79, 98], operation: .multiply(.scalar(19)), test: .init(23, ifTrue: 2, ifFalse: 3)),
        .init(items: [54, 65, 75, 74], operation: .add(.scalar(6)), test: .init(19, ifTrue: 2, ifFalse: 0)),
        .init(items: [79, 60, 97], operation: .multiply(.`self`), test: .init(13, ifTrue: 1, ifFalse: 3)),
        .init(items: [74], operation: .add(.scalar(3)), test: .init(17, ifTrue: 0, ifFalse: 1)),
    ])
    let partOne = await day.partOne()
    #expect(partOne == "10605")
    let partTwo = await day.partTwo()
    #expect(partTwo == "2713310158")
}
