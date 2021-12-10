
//
//  Day10.swift
//
//
//  Created by Aaron Sky on 12/9/21.
//

import Algorithms
import Base

struct Day10: Day {
    var lines: [String]

    init(_ input: Input) throws {
        lines = input.components(separatedBy: "\n")
    }

    func partOne() async -> String {
        let (_, errors) = findBadLines()
        let score = errors.sum { c in
            switch c {
            case ")":
                return 3
            case "]":
                return 57
            case "}":
                return 1197
            case ">":
                return 25137
            default:
                return 0
            }
        }

        return "\(score)"
    }

    func partTwo() async -> String {
        let (incompletions, _) = findBadLines()
        let score = incompletions
            .map { comp in
                comp.reduce(into: 0) { acc, c in
                    acc *= 5
                    switch c {
                    case ")":
                        acc += 1
                    case "]":
                        acc += 2
                    case "}":
                        acc += 3
                    case ">":
                        acc += 4
                    default:
                        return
                    }
                }
            }
            .sorted()
            .median()

        return "\(score)"
    }

    func findBadLines() -> (incompletions: [String], errors: [Character]) {
        lines.reduce(into: (incompletions: [], errors: [])) { acc, line in
            switch LineCompiler(line).compile() {
            case .complete:
                return
            case .incomplete(let c):
                acc.incompletions.append(c)
            case .error(let c):
                acc.errors.append(c)
            }
        }
    }

    struct LineCompiler {
        enum Result {
            case complete
            case incomplete(String)
            case error(Character)
        }

        var line: [Character]

        init(_ line: String) {
            self.line = Array(line)
        }

        func compile() -> Result {
            var chunk = line[...]

            return compileChunk(&chunk)
        }

        private func compileChunk(_ chunk: inout ArraySlice<Character>) -> Result {
            guard !chunk.isEmpty else {
                return .incomplete("")
            }

            while let next = chunk.first {
                let close: Character
                switch next {
                case "[":
                    close = "]"
                case "(":
                    close = ")"
                case "{":
                    close = "}"
                case "<":
                    close = ">"
                default:
                    return .complete
                }

                chunk = chunk.dropFirst()

                guard let peek = chunk.first else {
                    return .incomplete(String(close))
                }

                if peek != close {
                    switch compileChunk(&chunk) {
                    case .error(let c):
                        return .error(c)
                    case .incomplete(let s):
                        return .incomplete(s + String(close))
                    default:
                        break
                    }
                }

                guard let next = chunk.first else {
                    return .incomplete(String(close))
                }

                guard next == close else {
                    return .error(next)
                }

                chunk = chunk.dropFirst()
            }

            return .complete
        }
    }
}
