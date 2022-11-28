import Base

struct Day2: Day {
    var combination: [[Instruction]]

    init(
        _ input: Input
    ) throws {
        combination =
            input
            .components(separatedBy: "\n")
            .map { line in
                line.map { dir in
                    Instruction(rawValue: String(dir))!
                }
            }
    }

    func partOne() async -> String {
        "\(sequence(problem: .one).joined())"
    }

    func partTwo() async -> String {
        "\(sequence(problem: .two).joined())"
    }

    func sequence(problem: Keypad.Problem) -> [String] {
        let keypad = Keypad(problem: problem)
        var sequence: [String] = []

        for instructions in combination {
            sequence.append(keypad.keyPressed(instructions, startingFrom: sequence.last ?? "5"))
        }

        return sequence
    }

    struct Keypad {
        enum Problem {
            case one
            case two
        }

        var problem: Problem

        init(
            problem: Problem
        ) {
            self.problem = problem
        }

        func keyPressed(_ instructions: [Instruction], startingFrom key: String) -> String {
            var current = key
            for instruction in instructions {
                let next: String?
                switch problem {
                case .one:
                    next = partOneKey(adjacentTo: current, instruction: instruction)
                case .two:
                    next = partTwoKey(adjacentTo: current, instruction: instruction)
                }
                guard next != nil else {
                    continue
                }
                current = next!
            }
            return current
        }

        func partOneKey(adjacentTo num: String, instruction: Instruction) -> String? {
            switch (num, instruction) {
            case ("1", .up):
                return nil
            case ("1", .left):
                return nil
            case ("1", .down):
                return "4"
            case ("1", .right):
                return "2"
            case ("2", .up):
                return nil
            case ("2", .left):
                return "1"
            case ("2", .down):
                return "5"
            case ("2", .right):
                return "3"
            case ("3", .up):
                return nil
            case ("3", .left):
                return "2"
            case ("3", .down):
                return "6"
            case ("3", .right):
                return nil
            case ("4", .up):
                return "1"
            case ("4", .left):
                return nil
            case ("4", .down):
                return "7"
            case ("4", .right):
                return "5"
            case ("5", .up):
                return "2"
            case ("5", .left):
                return "4"
            case ("5", .down):
                return "8"
            case ("5", .right):
                return "6"
            case ("6", .up):
                return "3"
            case ("6", .left):
                return "5"
            case ("6", .down):
                return "9"
            case ("6", .right):
                return nil
            case ("7", .up):
                return "4"
            case ("7", .left):
                return nil
            case ("7", .down):
                return nil
            case ("7", .right):
                return "8"
            case ("8", .up):
                return "5"
            case ("8", .left):
                return "7"
            case ("8", .down):
                return nil
            case ("8", .right):
                return "9"
            case ("9", .up):
                return "6"
            case ("9", .left):
                return "8"
            case ("9", .down):
                return nil
            case ("9", .right):
                return nil
            default:
                return nil
            }
        }

        func partTwoKey(adjacentTo num: String, instruction: Instruction) -> String? {
            switch (num, instruction) {
            case ("1", .up):
                return nil
            case ("1", .left):
                return nil
            case ("1", .down):
                return "3"
            case ("1", .right):
                return nil
            case ("2", .up):
                return nil
            case ("2", .left):
                return nil
            case ("2", .down):
                return "6"
            case ("2", .right):
                return "3"
            case ("3", .up):
                return "1"
            case ("3", .left):
                return "2"
            case ("3", .down):
                return "7"
            case ("3", .right):
                return "4"
            case ("4", .up):
                return nil
            case ("4", .left):
                return "3"
            case ("4", .down):
                return "8"
            case ("4", .right):
                return nil
            case ("5", .up):
                return nil
            case ("5", .left):
                return nil
            case ("5", .down):
                return nil
            case ("5", .right):
                return "6"
            case ("6", .up):
                return "2"
            case ("6", .left):
                return "5"
            case ("6", .down):
                return "A"
            case ("6", .right):
                return "7"
            case ("7", .up):
                return "3"
            case ("7", .left):
                return "6"
            case ("7", .down):
                return "B"
            case ("7", .right):
                return "8"
            case ("8", .up):
                return "4"
            case ("8", .left):
                return "7"
            case ("8", .down):
                return "C"
            case ("8", .right):
                return "9"
            case ("9", .up):
                return nil
            case ("9", .left):
                return "8"
            case ("9", .down):
                return nil
            case ("9", .right):
                return nil
            case ("A", .up):
                return "6"
            case ("A", .left):
                return nil
            case ("A", .down):
                return nil
            case ("A", .right):
                return "B"
            case ("B", .up):
                return "7"
            case ("B", .left):
                return "A"
            case ("B", .down):
                return "D"
            case ("B", .right):
                return "C"
            case ("C", .up):
                return "8"
            case ("C", .left):
                return "B"
            case ("C", .down):
                return nil
            case ("C", .right):
                return nil
            case ("D", .up):
                return "B"
            case ("D", .left):
                return nil
            case ("D", .down):
                return nil
            case ("D", .right):
                return nil
            default:
                return nil
            }
        }
    }

    enum Instruction: String {
        case up = "U"
        case left = "L"
        case down = "D"
        case right = "R"
    }
}
