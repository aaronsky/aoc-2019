import Testing

@testable import Advent2019

@Test
func day8() async throws {
    let day = try await Year2019().day(for: 8)
    let partOne = await day.partOne()
    #expect(
        partOne
            == "100100110001100111101111010010100101001010000100001111010000100001110011100100101000010110100001000010010100101001010000100001001001100011101000011110"
    )
    let partTwo = await day.partTwo()
    #expect(partTwo == "")
}

@Test
func day8_simpleProgram1() async throws {
    let pixels = "0222112222120000"
    let layers = [Day8.Layer](
        rawImage: Day8.RawImage(
            pixels: pixels,
            width: 2,
            height: 2
        )
    )
    let combined = Day8.Layer(combining: layers)
    #expect(combined.description == "0110")
}
