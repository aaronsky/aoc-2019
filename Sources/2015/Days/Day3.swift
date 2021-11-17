//
//  Day3.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day3: Day {
    var instructions: [Direction]

    init(_ input: Input) throws {
        instructions = input.raw.map(Direction.init)
    }

    func partOne() async -> String {
        "\(uniqueHousesReceivingPresents())"
    }

    func partTwo() async -> String {
        "\(uniqueHousesReceivingPresentsTwoWorkers())"
    }

    func uniqueHousesReceivingPresents() -> Int {
        var currentPosition = Point(0, 0)
        var houses: Set<Point> = [currentPosition]

        for d in instructions {
            let offset = d.offset
            currentPosition += offset
            houses.insert(currentPosition)
        }

        return houses.count
    }

    func uniqueHousesReceivingPresentsTwoWorkers() -> Int {
        var currentSanta = Point(0, 0)
        var currentRobot = Point(0, 0)
        var trackingRobot = false

        var houses: Set<Point> = [currentSanta, currentRobot]

        for d in instructions {
            let offset = d.offset

            if trackingRobot {
                currentRobot += offset
                houses.insert(currentRobot)
                trackingRobot = false
            } else {
                currentSanta += offset
                houses.insert(currentSanta)
                trackingRobot = true
            }
        }

        return houses.count
    }

    struct Point: Hashable {
        var x: Int
        var y: Int

        init(_ x: Int, _ y: Int) {
            self.x = x
            self.y = y
        }

        static func +=(left: inout Point, right: Point) {
            left.x += right.x
            left.y += right.y
        }
    }

    enum Direction {
        case up
        case down
        case left
        case right

        var offset: Point {
            switch self {
            case .up:
                return Point(0, -1)
            case .down:
                return Point(0, 1)
            case .left:
                return Point(-1, 0)
            case .right:
                return Point(1, 0)
            }
        }

        init(_ c: Character) {
            switch c {
            case "^":
                self = .up
            case "v":
                self = .down
            case "<":
                self = .left
            case ">":
                self = .right
            default:
                fatalError("impossible directive \(c)")
            }
        }
    }
}
