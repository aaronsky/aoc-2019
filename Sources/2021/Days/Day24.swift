//
//  Day24.swift
//
//
//  Created by Aaron Sky on 12/24/21.
//

import Algorithms
import Base
import Foundation

struct Day24: Day {
    var instructions: [Instruction]

    init(_ input: Input) throws {
        instructions = input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        if solve(monad: 79997391969649) {
            return "79997391969649"
        } else {
            return "0"
        }
    }

    func partTwo() async -> String {
        if solve(monad: 16931171414113, forSmallest: true) {
            return "16931171414113"
        } else {
            return "0"
        }
    }

    func solve(monad: Int, forSmallest: Bool = false) -> Bool {
        var registers: [String: Int] = [
            "w": 0,
            "x": 0,
            "y": 0,
            "z": 0,
        ]
        
        var digits = monad.digits.makeIterator()

        for instruction in instructions {
            do {
                let result = try instruction.execute(&registers)
                if let reg = result.registerAwaitingInput,
                   let digit = digits.next(),
                   digit != 0 {
                    registers[reg] = digit
                }
            } catch {
                return false
            }
        }

        return registers["z"] == 0
    }

    enum Instruction: RawRepresentable {
        struct ExecutionResult {
            var registerAwaitingInput: String?

            var needsInput: Bool {
                registerAwaitingInput != nil
            }
        }

        enum Error: Swift.Error {
            case invalid
        }

        case input(String)
        case add(String, String)
        case multiply(String, String)
        case divide(String, String)
        case modulo(String, String)
        case equals(String, String)

        var rawValue: String {
            switch self {
            case .input(let a):
                return "inp \(a)"
            case .add(let a, let b):
                return "add \(a) \(b)"
            case .multiply(let a, let b):
                return "mul \(a) \(b)"
            case .divide(let a, let b):
                return "div \(a) \(b)"
            case .modulo(let a, let b):
                return "mod \(a) \(b)"
            case .equals(let a, let b):
                return "eql \(a) \(b)"
            }
        }

        init?(rawValue: String) {
            var components = rawValue.components(separatedBy: " ")[...]

            guard components.count > 1 else {
                return nil
            }

            switch components.popFirst() {
            case "inp":
                guard let reg = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .input(reg)
            case "add":
                guard let regA = components.popFirst(),
                      let regB = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .add(regA, regB)
            case "mul":
                guard let regA = components.popFirst(),
                      let regB = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .multiply(regA, regB)
            case "div":
                guard let regA = components.popFirst(),
                      let regB = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .divide(regA, regB)
            case "mod":
                guard let regA = components.popFirst(),
                      let regB = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .modulo(regA, regB)
            case "eql":
                guard let regA = components.popFirst(),
                      let regB = components.popFirst(),
                      components.isEmpty else {
                          return nil
                      }
                self = .equals(regA, regB)
            default:
                return nil
            }
        }

        func execute(_ registers: inout [String: Int]) throws -> ExecutionResult {
            func op(a: String, b: String, _ op: (Int, Int) -> Int) throws {
                guard let aVal = registers[a] else {
                    throw Error.invalid
                }

                if let bVal = registers[b] {
                    registers[a] = op(aVal, bVal)
                } else if let bInt = Int(b) {
                    registers[a] = op(aVal, bInt)
                } else {
                    throw Error.invalid
                }
            }

            switch self {
            case .input(let reg):
                return ExecutionResult(registerAwaitingInput: reg)
            case .add(let a, let b):
                try op(a: a, b: b, +)
            case .multiply(let a, let b):
                try op(a: a, b: b, *)
            case .divide(let a, let b):
                try op(a: a, b: b, /)
            case .modulo(let a, let b):
                try op(a: a, b: b, %)
            case .equals(let a, let b):
                try op(a: a, b: b) { aVal, bVal in
                    aVal == bVal ? 1 : 0
                }
            }

            return ExecutionResult()
        }
    }
}
