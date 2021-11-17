//
//  Day7.swift
//  
//
//  Created by Aaron Sky on 11/17/21.
//

import Base

struct Day7: Day {
    var instructions: [Instruction]

    init(_ input: Input) throws {
        instructions = try input.decodeMany(separatedBy: "\n")
    }

    func partOne() async -> String {
        var circuit = Circuit()
        circuit.evaluate(instructions)

        return "\(circuit["a"] ?? -1)"
    }

    func partTwo() async -> String {
        var instructions = self.instructions
        instructions[89] = Instruction(expression: "956",
                                       output: "b",
                                       executed: false)

        var circuit = Circuit()
        circuit.evaluate(instructions)

        return "\(circuit["a"] ?? -1)"
    }

    struct Instruction: RawRepresentable {
        var expression: String
        var output: String
        var executed: Bool

        var rawValue: String {
            "\(expression) -> \(output)"
        }

        init(expression: String, output: String, executed: Bool) {
            self.expression = expression
            self.output = output
            self.executed = executed
        }

        init?(rawValue: String) {
            let components = rawValue.components(separatedBy: " -> ")
            let (expression, output) = (components[0], components[1])
            self.init(expression: expression, output: output, executed: false)
        }
    }

    struct Circuit {
        var wires: [String: Int] = [:]

        subscript(_ key: String) -> Int? {
            Int(key) ?? wires[key]
        }

        mutating func evaluate(_ instructions: [Instruction]) {
            var instructions = instructions
            var evaluatedDuringCycle = false

            repeat {
                evaluatedDuringCycle = false
                for (i, instruction) in instructions.enumerated() {
                    if instruction.executed {
                        continue
                    }

                    evaluatedDuringCycle = true

                    if let value = parseExpression(instruction.expression) {
                        wires[instruction.output] = value
                        instructions[i].executed = true
                    }
                }
            } while evaluatedDuringCycle
        }

        private func parseExpression(_ expression: String) -> Int? {
            let input = expression
                .trimmingCharacters(in: .whitespaces)
                .components(separatedBy: " ")

            if input.count == 1 {
                return self[input[0]]
            } else if input.count == 2 && input[0] == "NOT" {
                return self[input[1]].map { ~$0 }
            }

            let (lhs, op, rhs) = (input[0], input[1], input[2])
            guard let lhsValue = self[lhs],
                  let rhsValue = self[rhs] else {
                      return nil
                  }

            switch op {
            case "AND":
                return lhsValue & rhsValue
            case "OR":
                return lhsValue | rhsValue
            case "LSHIFT":
                return lhsValue << rhsValue
            case "RSHIFT":
                return lhsValue >> rhsValue
            default:
                return nil
            }
        }
    }
}
