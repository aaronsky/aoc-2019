//
//  Day17.swift
//
//
//  Created by Aaron Sky on 12/17/21.
//

import Algorithms
import Base

struct Day17: Day {
    static let pattern = Regex(#"target area: x=(?<minX>-?\d+)..(?<maxX>-?\d+), y=(?<minY>-?\d+)..(?<maxY>-?\d+)"#)

    var targetX: ClosedRange<Int>
    var targetY: ClosedRange<Int>

    init(_ input: Input) throws {
        let (targetX, targetY): (ClosedRange<Int>, ClosedRange<Int>) = input.decode {
            guard let match = Self.pattern.firstMatch(in: $0),
                  let minX: Int = match.capture(withName: "minX"),
                  let maxX: Int = match.capture(withName: "maxX"),
                  let minY: Int = match.capture(withName: "minY"),
                  let maxY: Int = match.capture(withName: "maxY") else {
                      return nil
                  }
            return (minX...maxX, minY...maxY)
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
