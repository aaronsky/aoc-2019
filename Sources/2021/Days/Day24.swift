import Algorithms
import Base
import Foundation

struct Day24: Day {
    var answers: [Int: (Int, Int)] = [0: (0, 0)]

    init(_ input: Input) throws {
        func check(_ params: (Int, Int, Int), _ z: Int, _ w: Int) -> Int {
            if (z % 26) + params.1 != w {
                return z / params.0 * 26 + w + params.2
            } else {
                return z / params.0
            }
        }

        let instructions: [Instruction] = input.decodeMany(separatedBy: "\n")
        let params: [(Int, Int, Int)] = stride(from: 0, to: 18 * 14, by: 18)
            .map {
                guard let oneString = instructions[$0 + 4].params.1,
                      let one = Int(oneString),
                      let twoString = instructions[$0 + 5].params.1,
                      let two = Int(twoString),
                      let threeString = instructions[$0 + 15].params.1,
                      let three = Int(threeString) else {
                          preconditionFailure()
                      }

                return (one, two, three)
            }

        for param in params {
            answers = answers.reduce(into: [:]) { partialResult, storedAnswer in
                let (z, input) = storedAnswer
                for i in 1...9 {
                    let answer = check(param, z, i)
                    if param.0 == 1 || (param.0 == 26 && answer < z) {
                        let defaultValue = (input.0 * 10 + i, input.1 * 10 + i)
                        partialResult[answer] = (
                            min(partialResult[answer, default: defaultValue].0, defaultValue.0),
                            max(partialResult[answer, default: defaultValue].1, defaultValue.1)
                        )
                    }
                }
            }
        }
    }

    func partOne() async -> String {
        return "\(answers[0]!.1)"
    }

    func partTwo() async -> String {
        return "\(answers[0]!.0)"
    }

    enum Instruction: RawRepresentable {
        case input(String)
        case add(String, String)
        case multiply(String, String)
        case divide(String, String)
        case modulo(String, String)
        case equals(String, String)

        var params: (String, String?) {
            switch self {
            case .input(let a):
                return (a, nil)
            case .add(let a, let b):
                return (a, b)
            case .multiply(let a, let b):
                return (a, b)
            case .divide(let a, let b):
                return (a, b)
            case .modulo(let a, let b):
                return (a, b)
            case .equals(let a, let b):
                return (a, b)
            }
        }

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
    }
}
