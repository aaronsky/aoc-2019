import Algorithms
import Base
import RegexBuilder

struct Day17: Day {
    var targetX: ClosedRange<Int>
    var targetY: ClosedRange<Int>

    init(_ input: Input) throws {
        let minXRef = Reference<Int>()
        let maxXRef = Reference<Int>()
        let minYRef = Reference<Int>()
        let maxYRef = Reference<Int>()
        let pattern = Regex {
            "target area: x="
            TryCapture(as: minXRef) {
                Optionally("-")
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            ".."
            TryCapture(as: maxXRef) {
                Optionally("-")
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            ", y="
            TryCapture(as: minYRef) {
                Optionally("-")
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
            ".."
            TryCapture(as: maxYRef) {
                Optionally("-")
                OneOrMore(.digit)
            } transform: {
                Int($0)
            }
        }
        let (targetX, targetY): (ClosedRange<Int>, ClosedRange<Int>) = input.decode {
            guard let match = try? pattern.firstMatch(in: $0) else {
                return nil
            }
            return (match[minXRef]...match[maxXRef], match[minYRef]...match[maxYRef])
        }!

        self.targetX = targetX
        self.targetY = targetY
    }

    func partOne() async -> String {
        let maxYs = maximumYPositionsReachingTarget()

        return "\(maxYs.max()!)"
    }

    func partTwo() async -> String {
        let maxYs = maximumYPositionsReachingTarget()

        return "\(maxYs.count)"
    }

    func maximumYPositionsReachingTarget() -> [Int] {
        product(0..<200, -260..<1000)
            .compactMap { (dx, dy) in
                var (x, y, maxY, dx, dy) = (0, 0, 0, dx, dy)
                while true {
                    x += dx
                    y += dy
                    dx -= dx.signum()
                    dy -= 1
                    if y > maxY {
                        maxY = y
                    }
                    switch (targetX.contains(x), targetY.contains(y)) {
                    case (true, true):
                        return maxY
                    case (false, _) where dx == 0:
                        return nil
                    case (_, false) where dy < 0 && y < -260:
                        return nil
                    default:
                        continue
                    }
                }
            }
    }
}
