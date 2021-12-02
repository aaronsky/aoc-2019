//
//  Day2.swift
//
//
//  Created by Aaron Sky on 12/1/21.
//

import Base

struct Day2: Day {
    private var instructions: [Instruction]

    init(_ input: Input) throws {
        instructions = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        let position = depth(from: instructions)
        return "\(position.position.x * position.position.y)"
    }

    func partTwo() async -> String {
        let position = depth(from: instructions, shouldUseHeading: true)
        return "\(position.position.x * position.position.y)"
    }

    private func depth(from instructions: [Instruction], starting point: Point2 = .zero, shouldUseHeading: Bool = false) -> Vector2 {
        instructions.reduce(into: Vector2(point)) { vec, instruction in
            switch (instruction.direction, shouldUseHeading) {
            case (.up, true):
                vec.heading -= instruction.units
            case (.up, false):
                vec.position.y -= instruction.units
            case (.down, true):
                vec.heading += instruction.units
            case (.down, false):
                vec.position.y += instruction.units
            case (.forward, true):
                vec.position.x += instruction.units
                vec.position.y += vec.heading * instruction.units
            case (.forward, false):
                vec.position.x += instruction.units
            }
            if vec.position.y < 0 {
                vec.position.y = 0
            }
        }
    }

    private struct Instruction: RawRepresentable {
        var direction: Direction
        var units: Int

        enum Direction: String {
            case up
            case down
            case forward
        }

        var rawValue: String {
            "\(direction.rawValue) \(units)"
        }

        init?(rawValue: String) {
            let components = rawValue.components(separatedBy: " ").prefix(2)
            precondition(components.count == 2)
            guard let direction = Direction(rawValue: components[0]) else { return nil }
            guard let units = Int(components[1]) else { return nil }
            self.init(direction: direction, units: units)
        }

        init(direction: Direction, units: Int) {
            self.direction = direction
            self.units = units
        }
    }

    private struct Vector2 {
        var position: Point2
        var heading: Int = 0

        init(_ point: Point2) {
            self.init(x: point.x, y: point.y)
        }

        init(x: Int, y: Int) {
            position = Point2(x: x, y: y)
        }
    }
}
