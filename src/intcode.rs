use digits_iterator::*;

type Memory = Vec<i32>;

#[derive(Debug, Clone, Copy)]
enum InstructionArgument {
    Position(usize),
    Immediate(i32),
}

impl InstructionArgument {
    fn get(&self, mem: &Memory) -> i32 {
        match *self {
            InstructionArgument::Position(pos) => mem[pos],
            InstructionArgument::Immediate(value) => value,
        }
    }
}

enum ProgramCounter {
    Stride(usize),
    Halt,
    Jump(usize),
    StateChange(ExecutionState),
}

#[derive(Debug)]
pub enum ExecutionState {
    Halted,
    WaitingForInput,
    Output(i32),
}

struct Input(InstructionArgument, Option<i32>);

pub struct Intcode {
    mem: Memory,
    pc: usize,
    pending_input: Option<Input>,
    pending_output: Option<i32>,
}

impl Intcode {
    pub fn new(mem: Memory) -> Self {
        Intcode {
            mem,
            pc: 0,
            pending_input: None,
            pending_output: None,
        }
    }

    pub fn run(&mut self) -> ExecutionState {
        loop {
            let instruction = self.mem.get(self.pc).cloned();
            let call = match instruction {
                Some(code) => self.call(code),
                None => panic!("Address {} does not exist", self.pc),
            };
            match call {
                ProgramCounter::Stride(stride) => self.pc += stride,
                ProgramCounter::StateChange(state) => {
                    return state;
                }
                ProgramCounter::Jump(addr) => self.pc = addr,
                ProgramCounter::Halt => return ExecutionState::Halted,
            };
        }
    }

    pub fn set_input(&mut self, input: i32) {
        if let Some(Input(arg, _)) = self.pending_input.take() {
            self.pending_input = Some(Input(arg, Some(input)))
        }
    }

    fn call(&mut self, code: i32) -> ProgramCounter {
        let opcode = code % 100;
        let args = self.get_args(code);
        match opcode {
            1 => {
                let (augend, addend, sum) = args;
                self.add(augend.unwrap(), addend.unwrap(), sum.unwrap());
                ProgramCounter::Stride(4)
            }
            2 => {
                let (multiplier, multiplicand, product) = args;
                self.mult(multiplier.unwrap(), multiplicand.unwrap(), product.unwrap());
                ProgramCounter::Stride(4)
            }
            3 => {
                let (arg, _, _) = args;
                if let Some(Input(arg, Some(input))) = self.pending_input {
                    self.ld(arg, input);
                    self.pending_input = None;
                    ProgramCounter::Stride(2)
                } else {
                    self.pending_input = Some(Input(arg.unwrap(), None));
                    ProgramCounter::StateChange(ExecutionState::WaitingForInput)
                }
            }
            4 => {
                if let Some(_) = self.pending_output {
                    self.pending_output = None;
                    ProgramCounter::Stride(2)
                } else {
                    let (arg, _, _) = args;
                    let output = self.output_arg(&arg.unwrap());
                    self.pending_output = Some(output);
                    ProgramCounter::StateChange(ExecutionState::Output(output))
                }
            }
            5 => {
                let (arg0, arg1, _) = args;
                self.jump_if_true(arg0.unwrap(), arg1.unwrap())
            }
            6 => {
                let (arg0, arg1, _) = args;
                self.jump_if_false(arg0.unwrap(), arg1.unwrap())
            }
            7 => {
                let (lhs, rhs, addr) = args;
                self.less_than(lhs.unwrap(), rhs.unwrap(), addr.unwrap());
                ProgramCounter::Stride(4)
            }
            8 => {
                let (lhs, rhs, addr) = args;
                self.equals(lhs.unwrap(), rhs.unwrap(), addr.unwrap());
                ProgramCounter::Stride(4)
            }
            99 => ProgramCounter::Halt,
            _ => panic!(
                "opcode {} (evaluated as {}) @ {} is not supported {:?}",
                code, opcode, self.pc, args
            ),
        }
    }

    fn get_args(
        &mut self,
        code: i32,
    ) -> (
        Option<InstructionArgument>,
        Option<InstructionArgument>,
        Option<InstructionArgument>,
    ) {
        let mut args: Vec<InstructionArgument> = vec![];
        let mut digits = code.digits().rev().skip(2).take(3);
        for index in 0..=2 {
            if self.pc + index + 1 >= self.mem.len() {
                continue;
            }
            let value = self.mem[self.pc + index + 1];
            if let Some(digit) = digits.next() {
                let arg = match digit {
                    0 => InstructionArgument::Position(value as usize),
                    1 => InstructionArgument::Immediate(value),
                    _ => panic!("Unsupported digit for argument"),
                };
                args.push(arg);
            } else {
                args.push(InstructionArgument::Position(value as usize))
            }
        }
        let arg2 = args.pop();
        let arg1 = args.pop();
        let arg0 = if let Some(arg) = args.pop() {
            Some(arg)
        } else if let Some(arg) = arg1 {
            Some(arg)
        } else if let Some(arg) = arg2 {
            Some(arg)
        } else {
            None
        };
        (arg0, arg1, arg2)
    }

    fn add(
        &mut self,
        augend: InstructionArgument,
        addend: InstructionArgument,
        sum: InstructionArgument,
    ) {
        if let InstructionArgument::Position(sum_pos) = sum {
            self.mem[sum_pos] = augend.get(&self.mem) + addend.get(&self.mem);
        } else {
            panic!("Immediate mode is not supported for addition");
        }
    }

    fn mult(
        &mut self,
        multiplier: InstructionArgument,
        multiplicand: InstructionArgument,
        product: InstructionArgument,
    ) {
        if let InstructionArgument::Position(product_pos) = product {
            self.mem[product_pos] = multiplier.get(&self.mem) * multiplicand.get(&self.mem);
        } else {
            panic!("Immediate mode is not supported for multiplication");
        }
    }

    fn ld(&mut self, addr: InstructionArgument, input: i32) {
        if let InstructionArgument::Position(addr_pos) = addr {
            self.mem[addr_pos] = input;
        } else {
            panic!("Immediate mode is not supported for ld");
        }
    }

    fn output_arg(&mut self, addr: &InstructionArgument) -> i32 {
        addr.get(&self.mem)
    }

    fn jump_if_true(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if arg0.get(&self.mem) != 0 {
            ProgramCounter::Jump(arg1.get(&self.mem) as usize)
        } else {
            ProgramCounter::Stride(3)
        }
    }

    fn jump_if_false(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if arg0.get(&self.mem) == 0 {
            ProgramCounter::Jump(arg1.get(&self.mem) as usize)
        } else {
            ProgramCounter::Stride(3)
        }
    }

    fn less_than(
        &mut self,
        lhs: InstructionArgument,
        rhs: InstructionArgument,
        addr: InstructionArgument,
    ) {
        if let InstructionArgument::Position(addr_pos) = addr {
            if lhs.get(&self.mem) < rhs.get(&self.mem) {
                self.mem[addr_pos] = 1;
            } else {
                self.mem[addr_pos] = 0;
            }
        } else {
            panic!("Immediate mode is not supported for ld");
        }
    }

    fn equals(
        &mut self,
        lhs: InstructionArgument,
        rhs: InstructionArgument,
        addr: InstructionArgument,
    ) {
        if let InstructionArgument::Position(addr_pos) = addr {
            if lhs.get(&self.mem) == rhs.get(&self.mem) {
                self.mem[addr_pos] = 1;
            } else {
                self.mem[addr_pos] = 0;
            }
        } else {
            panic!("Immediate mode is not supported for ld");
        }
    }

    pub fn dump_memory(&self) -> String {
        format!("{:?}", self.mem)
    }
}
