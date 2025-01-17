import Testing

@testable import Advent2021

@Test
func day22() async throws {
    let day = try await Year2021().day(for: 22)
    let partOne = await day.partOne()
    #expect(Int(partOne) == 648023)
    let partTwo = await day.partTwo()
    #expect(Int(partTwo) == 1_285_677_377_848_549)
}

@Test
func day22_simpleProblem1() throws {
    let reactor = Day22.Reactor(steps: [
        .init(state: .on, x: 10...12, y: 10...12, z: 10...12),
        .init(state: .on, x: 11...13, y: 11...13, z: 11...13),
        .init(state: .off, x: 9...11, y: 10...11, z: 9...11),
        .init(state: .on, x: 10...10, y: 10...10, z: 10...10),
    ])
    let onCubes = reactor.reboot(initializationAreaOnly: true)
    #expect(onCubes == 39)
}

@Test
func day22_simpleProblem2() throws {
    let reactor = Day22.Reactor(steps: [
        .init(state: .on, x: -20...26, y: -36...17, z: -47...7),
        .init(state: .on, x: -20...33, y: -21...23, z: -26...28),
        .init(state: .on, x: -22...28, y: -29...23, z: -38...16),
        .init(state: .on, x: -46...7, y: -6...46, z: -50 ... -1),
        .init(state: .on, x: -49...1, y: -3...46, z: -24...28),
        .init(state: .on, x: 2...47, y: -22...22, z: -23...27),
        .init(state: .on, x: -27...23, y: -28...26, z: -21...29),
        .init(state: .on, x: -39...5, y: -6...47, z: -3...44),
        .init(state: .on, x: -30...21, y: -8...43, z: -13...34),
        .init(state: .on, x: -22...26, y: -27...20, z: -29...19),
        .init(state: .off, x: -48 ... -32, y: 26...41, z: -47 ... -37),
        .init(state: .on, x: -12...35, y: 6...50, z: -50 ... -2),
        .init(state: .off, x: -48 ... -32, y: -32 ... -16, z: -15 ... -5),
        .init(state: .on, x: -18...26, y: -33...15, z: -7...46),
        .init(state: .off, x: -40 ... -22, y: -38 ... -28, z: 23...41),
        .init(state: .on, x: -16...35, y: -41...10, z: -47...6),
        .init(state: .off, x: -32 ... -23, y: 11...30, z: -14...3),
        .init(state: .on, x: -49 ... -5, y: -3...45, z: -29...18),
        .init(state: .off, x: 18...30, y: -20 ... -8, z: -3...13),
        .init(state: .on, x: -41...9, y: -7...43, z: -33...15),
        .init(state: .on, x: -54112 ... -39298, y: -85059 ... -49293, z: -27449...7877),
        .init(state: .on, x: 967...23432, y: 45373...81175, z: 27513...53682),
    ])
    let onCubes = reactor.reboot(initializationAreaOnly: true)
    #expect(onCubes == 590784)
}
