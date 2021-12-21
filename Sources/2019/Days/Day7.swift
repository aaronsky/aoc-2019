//
//  Day7.swift
//
//
//  Created by Aaron Sky on 11/20/21.
//

import Algorithms
import Base

struct Day7: Day {
    var rom: [Int]

    init(_ input: Input) throws {
        rom = input.decodeMany(separatedBy: ",")
    }

    func partOne() async -> String {
        let possibleNumbers: Set<Int> = [0, 1, 2, 3, 4]
        let maxOutput = possibleNumbers
            .permutations()
            .map { Self.output(forAmplifierSequence: $0, rom: rom) }
            .max()
        return "\(maxOutput ?? -1)"
    }

    func partTwo() async -> String {
        let possibleNumbers: Set<Int> = [5, 6, 7, 8, 9]
        let maxOutput = possibleNumbers
            .permutations()
            .map { Self.output(forAmplifierSequence: $0, rom: rom) }
            .max()
        return "\(maxOutput ?? -1)"
    }

    static func output(forAmplifierSequence sequence: [Int], rom: [Int]) -> Int {
        var programs: [Intcode] = Array(repeating: Intcode(program: rom),
                                        count: sequence.count)
        for i in programs.indices {
            programs[i].run()
            programs[i].set(input: sequence[i])
            programs[i].run()
        }

        var output = 0

        while true {
            var halted = false
            for i in programs.indices {
                programs[i].set(input: output)
                switch programs[i].run() {
                case .waitingForInput:
                    continue
                case .output(let o):
                    output = o
                case .halted:
                    halted = true
                }
            }
            if halted {
                break
            }
        }

        return output
    }
}
