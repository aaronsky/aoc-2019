import Algorithms
import Base
import RegexBuilder

struct Day11: Day {
    struct Monkey {
        enum Operation {
            case add(Discriminant)
            case multiply(Discriminant)

            enum Discriminant {
                case `self`
                case scalar(Int)
            }

            static func add(_ scalar: Int) -> Self {
                .add(.scalar(scalar))
            }

            static func multiply(_ scalar: Int) -> Self {
                .add(.scalar(scalar))
            }

            func callAsFunction(_ item: Int) -> Int {
                switch self {
                case .add(.`self`):
                    return item + item
                case .add(.scalar(let incr)):
                    return item + incr
                case .multiply(.`self`):
                    return item * item
                case .multiply(.scalar(let incr)):
                    return item * incr
                }
            }
        }

        struct Test {
            var factor: Int
            var ifTrue: Int
            var ifFalse: Int

            init(_ factor: Int, ifTrue: Int, ifFalse: Int) {
                self.factor = factor
                self.ifTrue = ifTrue
                self.ifFalse = ifFalse
            }

            func callAsFunction(_ level: Int) -> Int {
                level.isMultiple(of: factor) ? ifTrue : ifFalse
            }
        }

        var items: [Int]
        var operation: Operation
        var test: Test

        init(items: [Int], operation: Operation, test: Test) {
            self.items = items
            self.operation = operation
            self.test = test
        }

        init?(rawValue: String) {
            let idRef = Reference<Int>()
            let itemsRef = Reference<[Int]>()
            let operatorRef = Reference<Substring>()
            let discriminantRef = Reference<Substring>()
            let testFactorRef = Reference<Int>()
            let ifTrueRef = Reference<Int>()
            let ifFalseRef = Reference<Int>()
            let pattern = Regex {
                "Monkey "
                TryCapture(OneOrMore(.digit), as: idRef) { Int($0) }
                One(.newlineSequence)

                ZeroOrMore(.whitespace)
                "Starting items: "
                TryCapture(as: itemsRef) {
                    OneOrMore {
                        OneOrMore(.digit)
                        Optionally(", ")
                    }
                } transform: {
                    var items: [Int] = []
                    for substring in $0.split(separator: ", ") {
                        guard let item = Int(String(substring)) else { return nil }
                        items.append(item)
                    }
                    return items
                }
                One(.newlineSequence)

                ZeroOrMore(.whitespace)
                "Operation: new = old "
                Capture(as: operatorRef) {
                    ChoiceOf {
                        "+"
                        "*"
                    }
                }
                ZeroOrMore(.whitespace)
                Capture(as: discriminantRef) {
                    ChoiceOf {
                        "old"
                        OneOrMore(.digit)
                    }
                }
                One(.newlineSequence)

                ZeroOrMore(.whitespace)
                "Test: divisible by "
                TryCapture(OneOrMore(.digit), as: testFactorRef) { Int($0) }
                One(.newlineSequence)

                ZeroOrMore(.whitespace)
                "If true: throw to monkey "
                TryCapture(OneOrMore(.digit), as: ifTrueRef) { Int($0) }
                One(.newlineSequence)

                ZeroOrMore(.whitespace)
                "If false: throw to monkey "
                TryCapture(OneOrMore(.digit), as: ifFalseRef) { Int($0) }
            }

            guard let match = rawValue.firstMatch(of: pattern) else { return nil }

            self.init(
                items: match[itemsRef],
                operation: { op, disc in
                    let discr: Operation.Discriminant = disc == "old" ? .`self` : .scalar(Int(disc)!)
                    switch op {
                    case "+":
                        return .add(discr)
                    case "*":
                        return .multiply(discr)
                    default:
                        fatalError()
                    }
                }(match[operatorRef], match[discriminantRef]),
                test: .init(match[testFactorRef], ifTrue: match[ifTrueRef], ifFalse: match[ifFalseRef])
            )
        }
    }

    let monkeys: [Monkey]

    init(_ input: Input) throws {
        let monkeys = input.decodeMany(separatedBy: "\n\n", transform: Monkey.init(rawValue:))
        self.init(monkeys: monkeys)
    }

    init(monkeys: [Monkey]) {
        self.monkeys = monkeys
    }

    func partOne() async -> String {
        var monkeys = monkeys
        var inspections: [Int] = Array(repeating: 0, count: monkeys.count)
        for _ in 1...20 {
            for i in monkeys.indices {
                inspections[i] += monkeys[i].items.count
                for item in monkeys[i].items {
                    let worryLevel = monkeys[i].operation(item)
                    let boredLevel = worryLevel / 3
                    let newIndex = monkeys[i].test(boredLevel)
                    monkeys[newIndex].items.append(boredLevel)
                }
                monkeys[i].items.removeAll()
            }
        }

        return "\(inspections.max(count: 2).product)"
    }

    func partTwo() async -> String {
        var monkeys = monkeys
        let divisor = monkeys.product(of: \.test.factor)
        var inspections: [Int] = Array(repeating: 0, count: monkeys.count)

        for _ in 1...10000 {
            for i in monkeys.indices {
                inspections[i] += monkeys[i].items.count

                for item in monkeys[i].items {
                    let worryLevel = monkeys[i].operation(item) % divisor
                    let newIndex = monkeys[i].test(worryLevel)
                    monkeys[newIndex].items.append(worryLevel)
                }

                monkeys[i].items.removeAll()
            }
        }

        return "\(inspections.max(count: 2).product)"
    }
}
