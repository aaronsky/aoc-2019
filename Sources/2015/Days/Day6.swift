//
//  Day6.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day6: Day {
    var instructions: [Instruction]

    init(_ input: Input) throws {
        instructions = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        var lights = LightBoard(mode: .onOff)

        lights.apply(instructions: instructions)

        return "\(lights.totalOn)"
    }

    func partTwo() async -> String {
        var lights = LightBoard(mode: .brightness)

        lights.apply(instructions: instructions)

        return "\(lights.totalBrightness)"
    }

    struct LightBoard {
        var lights: [Int] = .init(repeating: 0, count: 1_000_000)
        var mode: Mode

        var totalOn: Int {
            lights
                .lazy
                .count(where: { $0 > 0 })
        }

        var totalBrightness: Int {
            lights.sum
        }

        subscript(x: Array<Int>.Index, y: Array<Int>.Index) -> Array<Int>.Index {
            1000 * x + y
        }

        mutating func apply(instructions: [Instruction]) {
            for instruction in instructions {
                for x in instruction.start.0...instruction.end.0 {
                    for y in instruction.start.1...instruction.end.1 {
                        perform(action: instruction.action, x: x, y: y)
                    }
                }
            }
        }

        mutating func perform(action: Instruction.Action, x: Int, y: Int) {
            let pos = self[x, y]

            switch mode {
            case .onOff:
                switch action {
                case .on:
                    lights[pos] = 1
                case .off:
                    lights[pos] = 0
                case .toggle:
                    lights[pos] = 1 - lights[pos]
                }
            case .brightness:
                switch action {
                case .on:
                    lights[pos] += 1
                case .off:
                    lights[pos] -= 1
                    if lights[pos] < 0 {
                        lights[pos] = 0
                    }
                case .toggle:
                    lights[pos] += 2
                }
            }
        }

        enum Mode {
            case onOff
            case brightness
        }
    }

    struct Instruction: RawRepresentable {
        var action: Action
        var start: (Int, Int)
        var end: (Int, Int)

        var rawValue: String {
            "\(action) \(start) through \(end)"
        }

        init?(rawValue: String) {
            let coordsStr: String
            if let c = rawValue.strippingPrefix(Action.on.rawValue) {
                coordsStr = c
                action = .on
            } else if let c = rawValue.strippingPrefix(Action.off.rawValue) {
                coordsStr = c
                action = .off
            } else if let c = rawValue.strippingPrefix(Action.toggle.rawValue) {
                coordsStr = c
                action = .toggle
            } else {
                return nil
            }

            let coords = coordsStr
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: "through")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .prefix(2)

            let (startStr, endStr) = (coords[0], coords[1])

            let startComps = startStr
                .components(separatedBy: ",")
                .prefix(2)
                .compactMap(Int.init)
            start = (startComps[0], startComps[1])

            let endComps = endStr
                .components(separatedBy: ",")
                .prefix(2)
                .compactMap(Int.init)
            end = (endComps[0], endComps[1])
        }

        enum Action: String {
            case on = "turn on"
            case off = "turn off"
            case toggle = "toggle"
        }
    }
}

extension String {
    func strippingPrefix(_ prefix: String) -> String? {
        guard hasPrefix(prefix) else {
            return nil
        }
        return String(dropFirst(prefix.count))
    }
}
