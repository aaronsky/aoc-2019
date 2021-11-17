//
//  Day1.swift
//  
//
//  Created by Aaron Sky on 11/16/21.
//

import Algorithms
import Base

struct Day1: Day {
    let pattern: String

    init(_ input: Input) throws {
        pattern = input.raw
    }

    func partOne() -> String {
        "\(floorNumber())"
    }

    func partTwo() -> String {
        "\(floorNumberIndex(target: -1))"
    }

    func floorNumber() -> Int {
        var currentFloor = 0

        for p in pattern {
            switch p {
            case "(":
                currentFloor += 1
            case ")":
                currentFloor -= 1
            case "\n":
                continue
            default:
                fatalError("impossible directive \(p)")
            }
        }

        return currentFloor
    }

    func floorNumberIndex(target: Int) -> Int {
        var currentFloor = 0

        for (i, p) in pattern.enumerated() {
            switch p {
            case "(":
                currentFloor += 1
            case ")":
                currentFloor -= 1
            case "\n":
                break
            default:
                fatalError("impossible directive \(p)")
            }

            if currentFloor == target {
                return i + 1
            }
        }

        return Int.max
    }

}
