//
//  Intcode.swift
//  
//
//  Created by Aaron Sky on 11/18/21.
//

import Foundation

struct Intcode: CustomDebugStringConvertible {
    private var memory: Memory
    private var pendingInput: Intcode.Input?
    private var pendingOutput: Int?

    var debugDescription: String {
        memory.debugDescription
    }

    init(program: [Int]) {
        memory = Memory(program: program)
    }

    @discardableResult
    mutating func run() -> Interrupt {
        while true {
            let call: ProgramCounter
            if let instruction = memory.instruction {
                do {
                    call = try self.call(instruction)
                } catch {
                    fatalError(error.localizedDescription)
                }
            } else {
                fatalError("Address \(memory.programCounter) does not exist")
            }
            switch call {
            case .stride(let stride):
                memory.programCounter += stride
            case .interrupt(let cause):
                return cause
            case .jump(let addr):
                memory.programCounter = addr
            case .halt:
                return .halted
            }
        }
    }

    mutating func call(_ code: Int) throws -> ProgramCounter {
        guard let opcode = Opcode(rawValue: code % 100) else {
            throw Opcode.Error.invalid(code)
        }

        switch opcode {
        case .add:
            let (augend, addend, sum) = (
                self.getArgument(code: code, index: 0),
                self.getArgument(code: code, index: 1),
                self.getArgument(code: code, index: 2)
        )
            add(augend, addend, sum)
            return .stride(4)
        case .multiply:
            let (multiplier, multiplicand, product) = (
                    self.getArgument(code: code, index: 0),
                    self.getArgument(code: code, index: 1),
                    self.getArgument(code: code, index: 2)
            )
            mult(multiplier, multiplicand, product)
            return .stride(4)
        case .load:
            if let pendingInput = pendingInput, let input = pendingInput.value {
                ld(pendingInput.arg, input)
                self.pendingInput = nil
                return .stride(2)
            } else {
                let arg = getArgument(code: code, index: 0)
                self.pendingInput = Input(arg: arg, value: nil)
                return .interrupt(.waitingForInput)
            }
        case .output:
            if pendingOutput != nil {
                self.pendingOutput = nil
                return .stride(2)
            } else {
                let arg = getArgument(code: code, index: 0)
                let output = outputArgument(arg)
                self.pendingOutput = output
                return .interrupt(.output(output))
            }
        case .jumpIfTrue:
            let (arg0, arg1) = (
                self.getArgument(code: code, index: 0),
                self.getArgument(code: code, index: 1)
            )
            return jumpIfTrue(arg0, arg1)
        case .jumpIfFalse:
            let (arg0, arg1) = (
                self.getArgument(code: code, index: 0),
                self.getArgument(code: code, index: 1)
            )
            return jumpIfFalse(arg0, arg1)
        case .lessThan:
            let (lhs, rhs, addr) = (
                self.getArgument(code: code, index: 0),
                self.getArgument(code: code, index: 1),
                self.getArgument(code: code, index: 2)
        )
            lessThan(lhs, rhs, addr)
            return .stride(4)
        case .equals:
            let (lhs, rhs, addr) = (
                self.getArgument(code: code, index: 0),
                self.getArgument(code: code, index: 1),
                self.getArgument(code: code, index: 2)
        )
            equals(lhs, rhs, addr)
            return .stride(4)
        case .setRelativeBase:
            let arg = getArgument(code: code, index: 0)
            memory.adjustRelativeBase(memory[arg])
            return .stride(2)
        case .halt:
            return .halt
        }
    }

    func getArgument(code: Int, index: Int) -> InstructionArgument {
        let power = index + 2
        let mask = pow(10, Double(power))
        let mode = (code / Int(mask)) % 10
        let value = memory[memory.programCounter + index + 1]

        return InstructionArgument(mode: mode, value: value)
    }

    mutating func set(input value: Int) {
        guard let input = pendingInput else {
            return
        }

        pendingInput = Input(arg: input.arg, value: value)
    }

    mutating func set(address: Int, value: Int) {
        memory[address] = value
    }

    mutating func add(_ augend: InstructionArgument, _ addend: InstructionArgument, _ sum: InstructionArgument) {
        memory[sum] = memory[augend] + memory[addend]
    }

    mutating func mult(_ multiplier: InstructionArgument, _ multiplicand: InstructionArgument, _ product: InstructionArgument) {
        memory[product] = memory[multiplier] * memory[multiplicand]
    }

    mutating func ld(_ addr: InstructionArgument, _ input: Int) {
        memory[addr] = input
    }

    mutating func outputArgument(_ addr: InstructionArgument) -> Int {
        memory[addr]
    }

    mutating func jumpIfTrue(_ arg0: InstructionArgument, _ arg1: InstructionArgument) -> ProgramCounter {
        if memory[arg0] != 0 {
            return .jump(memory[arg1])
        } else {
            return .stride(3)
        }
    }

    mutating func jumpIfFalse(_ arg0: InstructionArgument, _ arg1: InstructionArgument) -> ProgramCounter {
        if memory[arg0] == 0 {
            return .jump(memory[arg1])
        } else {
            return .stride(3)
        }
    }

    mutating func lessThan(_ lhs: InstructionArgument, _ rhs: InstructionArgument, _ addr: InstructionArgument) {
        if memory[lhs] < memory[rhs] {
            memory[addr] = 1
        } else {
            memory[addr] = 0
        }
    }

    mutating func equals(_ lhs: InstructionArgument, _ rhs: InstructionArgument, _ addr: InstructionArgument) {
        if memory[lhs] == memory[rhs] {
            memory[addr] = 1
        } else {
            memory[addr] = 0
        }
    }

    struct Memory: CustomDebugStringConvertible {
        var ram: [Int]
        var programSize: Int
        var programCounter: Int = 0
        var relativeBase: Int = 0

        var instruction: Int? {
            ram.indices.contains(programCounter) ? ram[programCounter] : nil
        }

        var debugDescription: String {
            "\(ram)"
        }

        init(program: [Int]) {
            ram = .init(repeating: 0, count: program.count * 2)
            ram.replaceSubrange(..<program.count, with: program)
            programSize = program.count
        }

        subscript(arg: InstructionArgument) -> Int {
            get {
                switch arg {
                case .position(let addr):
                    return ram[addr]
                case .immediate(let value):
                    return value
                case .relative(let addr):
                    return ram[relativeBase + addr]
                }
            }
            set {
                switch arg {
                case .position(let addr):
                    ram[addr] = newValue
                case .immediate:
                    fatalError("writes with immediate arguments are not supported")
                case .relative(let addr):
                    ram[relativeBase + addr] = newValue
                }
            }
        }

        subscript(_ index: Array<Int>.Index) -> Int {
            get {
                ram[index]
            }
            set {
                ram[index] = newValue
            }
        }

        mutating func adjustRelativeBase(_ modifier: Int) {
            if modifier < 0 {
                relativeBase -= abs(modifier)
            } else {
                relativeBase += modifier
            }
        }
    }

    struct Input {
        var arg: InstructionArgument
        var value: Int?
    }

    enum InstructionArgument {
        case position(Int)
        case immediate(Int)
        case relative(Int)

        init(mode: Int, value: Int) {
            switch mode {
            case 0:
                self = .position(value)
            case 1:
                self = .immediate(value)
            case 2:
                self = .relative(value)
            default:
                fatalError("unsupported instruction argument value \(mode)")
            }
        }
    }

    enum ProgramCounter {
        case stride(Int)
        case interrupt(Interrupt)
        case jump(Int)
        case halt
    }

    enum Interrupt {
        case halted
        case waitingForInput
        case output(Int)
    }

    enum Opcode: Int {
        case add = 1
        case multiply = 2
        case load = 3
        case output = 4
        case jumpIfTrue = 5
        case jumpIfFalse = 6
        case lessThan = 7
        case equals = 8
        case setRelativeBase = 9
        case halt = 99

        enum Error: Swift.Error {
            case invalid(Int)
        }
    }
}
