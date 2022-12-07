import Algorithms
import Base

struct Day6: Day {
    var stream: String

    init(
        _ input: Input
    ) throws {
        stream = input.raw
    }

    func partOne() async -> String {
        firstMarker(ofSize: 4, stream: stream) ?? ""
    }

    func partTwo() async -> String {
        firstMarker(ofSize: 14, stream: stream) ?? ""
    }

    func firstMarker(ofSize size: Int, stream: String) -> String? {
        Array(stream)
            .windows(ofCount: size)
            .first(where: \.allUnique)
            .map { "\($0.endIndex)" }
    }
}
