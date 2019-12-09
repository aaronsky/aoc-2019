use digits_iterator::*;

type Program = Vec<i64>;
type Memory = Vec<i64>;

#[derive(Debug, Clone, Copy)]
enum InstructionArgument {
    Position(usize),
    Immediate(i64),
    Relative(isize),
}

impl InstructionArgument {
    fn get(&self, mem: &Memory, relative_base: &usize) -> i64 {
        match *self {
            InstructionArgument::Position(pos) => mem[pos],
            InstructionArgument::Immediate(value) => value,
            InstructionArgument::Relative(value) => {
                mem[((*relative_base as isize) + value) as usize]
            }
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
    Output(i64),
}

struct Input(InstructionArgument, Option<i64>);

pub struct Intcode {
    mem: Memory,
    pc: usize,
    relative_base: usize,
    pending_input: Option<Input>,
    pending_output: Option<i64>,
}

impl Intcode {
    pub fn new(program: Program) -> Self {
        let mut mem = vec![0; program.len() * 2];
        for i in 0..program.len() {
            mem[i] = program[i];
        }
        Intcode {
            mem,
            pc: 0,
            relative_base: 0,
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

    pub fn set_input(&mut self, input: i64) {
        if let Some(Input(arg, _)) = self.pending_input.take() {
            self.pending_input = Some(Input(arg, Some(input)))
        }
    }

    fn call(&mut self, code: i64) -> ProgramCounter {
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
            9 => {
                let (arg, _, _) = args;
                self.set_relative_base(arg.unwrap());
                ProgramCounter::Stride(2)
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
        code: i64,
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
                    2 => InstructionArgument::Relative(value as isize),
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
        match sum {
            InstructionArgument::Position(sum_pos) => {
                self.mem[sum_pos] = augend.get(&self.mem, &self.relative_base)
                    + addend.get(&self.mem, &self.relative_base);
            }
            InstructionArgument::Relative(sum_pos) => {
                self.mem[((self.relative_base as isize) + sum_pos) as usize] = augend
                    .get(&self.mem, &self.relative_base)
                    + addend.get(&self.mem, &self.relative_base);
            }
            InstructionArgument::Immediate(_) => {
                panic!("Immediate mode is not supported for addition")
            }
        };
    }

    fn mult(
        &mut self,
        multiplier: InstructionArgument,
        multiplicand: InstructionArgument,
        product: InstructionArgument,
    ) {
        match product {
            InstructionArgument::Position(product_pos) => {
                self.mem[product_pos] = multiplier.get(&self.mem, &self.relative_base)
                    * multiplicand.get(&self.mem, &self.relative_base)
            }
            InstructionArgument::Relative(product_pos) => {
                self.mem[((self.relative_base as isize) + product_pos) as usize] = multiplier
                    .get(&self.mem, &self.relative_base)
                    * multiplicand.get(&self.mem, &self.relative_base)
            }
            InstructionArgument::Immediate(_) => {
                panic!("Immediate mode is not supported for multiplication")
            }
        };
    }

    fn ld(&mut self, addr: InstructionArgument, input: i64) {
        match addr {
            InstructionArgument::Position(addr_pos) => self.mem[addr_pos] = input,
            InstructionArgument::Relative(addr_pos) => {
                self.mem[((self.relative_base as isize) + addr_pos) as usize] = input
            }
            InstructionArgument::Immediate(_) => panic!("Immediate mode is not supported for ld"),
        };
    }

    fn output_arg(&mut self, addr: &InstructionArgument) -> i64 {
        addr.get(&self.mem, &self.relative_base)
    }

    fn jump_if_true(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if arg0.get(&self.mem, &self.relative_base) != 0 {
            ProgramCounter::Jump(arg1.get(&self.mem, &self.relative_base) as usize)
        } else {
            ProgramCounter::Stride(3)
        }
    }

    fn jump_if_false(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if arg0.get(&self.mem, &self.relative_base) == 0 {
            ProgramCounter::Jump(arg1.get(&self.mem, &self.relative_base) as usize)
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
        match addr {
            InstructionArgument::Position(addr_pos) => {
                if lhs.get(&self.mem, &self.relative_base) < rhs.get(&self.mem, &self.relative_base)
                {
                    self.mem[addr_pos] = 1;
                } else {
                    self.mem[addr_pos] = 0;
                }
            }
            InstructionArgument::Relative(addr_pos) => {
                let write_addr = ((self.relative_base as isize) + addr_pos) as usize;
                if lhs.get(&self.mem, &self.relative_base) < rhs.get(&self.mem, &self.relative_base)
                {
                    self.mem[write_addr] = 1;
                } else {
                    self.mem[write_addr] = 0;
                }
            }
            InstructionArgument::Immediate(_) => {
                panic!("Immediate mode is not supported for less_than")
            }
        };
    }

    fn equals(
        &mut self,
        lhs: InstructionArgument,
        rhs: InstructionArgument,
        addr: InstructionArgument,
    ) {
        match addr {
            InstructionArgument::Position(addr_pos) => {
                if lhs.get(&self.mem, &self.relative_base)
                    == rhs.get(&self.mem, &self.relative_base)
                {
                    self.mem[addr_pos] = 1;
                } else {
                    self.mem[addr_pos] = 0;
                }
            }
            InstructionArgument::Relative(addr_pos) => {
                let write_addr = ((self.relative_base as isize) + addr_pos) as usize;
                if lhs.get(&self.mem, &self.relative_base)
                    == rhs.get(&self.mem, &self.relative_base)
                {
                    self.mem[write_addr] = 1;
                } else {
                    self.mem[write_addr] = 0;
                }
            }
            InstructionArgument::Immediate(_) => {
                panic!("Immediate mode is not supported for equals")
            }
        };
    }

    fn set_relative_base(&mut self, arg: InstructionArgument) {
        let modifier = arg.get(&self.mem, &self.relative_base);
        if modifier < 0 {
            self.relative_base -= i64::abs(modifier) as usize;
        } else {
            self.relative_base += modifier as usize;
        }
    }

    pub fn dump_memory(&self) -> String {
        format!("{:?}", self.mem)
    }
}
