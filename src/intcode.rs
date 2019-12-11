use std::ops::{Index, IndexMut};

#[derive(Debug, Clone, Copy)]
enum InstructionArgument {
    Position(usize),
    Immediate(i64),
    Relative(isize),
}

impl InstructionArgument {
    fn from(mode: u8, value: i64) -> Self {
        match mode {
            0 => InstructionArgument::Position(value as usize),
            1 => InstructionArgument::Immediate(value),
            2 => InstructionArgument::Relative(value as isize),
            _ => panic!("unsupported instruction argument value {}", mode),
        }
    }
}

#[derive(Debug)]
struct Memory {
    ram: Vec<i64>,
    program_size: usize,
    program_counter: usize,
    relative_base: usize,
}

impl Memory {
    fn load_program(program: &[i64]) -> Self {
        let mut ram = vec![0; program.len() * 2];
        ram[..program.len()].clone_from_slice(&program[..]);
        Memory {
            ram,
            program_size: program.len(),
            program_counter: 0,
            relative_base: 0,
        }
    }

    fn get_instruction(&self) -> Option<i64> {
        self.ram.get(self.program_counter).cloned()
    }

    fn get(&self, arg: InstructionArgument) -> i64 {
        match arg {
            InstructionArgument::Position(addr) => self.ram[addr],
            InstructionArgument::Immediate(value) => value,
            InstructionArgument::Relative(rel_addr) => {
                let addr = ((self.relative_base as isize) + rel_addr) as usize;
                self.ram[addr]
            }
        }
    }

    fn set(&mut self, arg: InstructionArgument, value: i64) {
        match arg {
            InstructionArgument::Position(addr) => self.ram[addr] = value,
            InstructionArgument::Immediate(_) => {
                panic!("writes with immediate arguments are not supported")
            }
            InstructionArgument::Relative(rel_addr) => {
                let addr = ((self.relative_base as isize) + rel_addr) as usize;
                self.ram[addr] = value;
            }
        };
    }

    fn checked_adjust_relative_base(&mut self, modifier: i64) {
        if modifier < 0 {
            self.relative_base -= i64::abs(modifier) as usize;
        } else {
            self.relative_base += modifier as usize;
        }
    }

    fn dump(&self) -> String {
        format!("{:?}", self.ram)
    }
}

impl Index<usize> for Memory {
    type Output = i64;

    fn index(&self, index: usize) -> &Self::Output {
        &self.ram[index]
    }
}

impl IndexMut<usize> for Memory {
    fn index_mut(&mut self, index: usize) -> &mut Self::Output {
        &mut self.ram[index]
    }
}

#[derive(Debug)]
enum ProgramCounter {
    Stride(usize),
    Interrupt(Interrupt),
    Jump(usize),
    Halt,
}

#[derive(Debug)]
pub enum Interrupt {
    Halted,
    WaitingForInput,
    Output(i64),
}

enum Opcode {
    Add = 1,
    Multiply = 2,
    Load = 3,
    Output = 4,
    JumpIfTrue = 5,
    JumpIfFalse = 6,
    LessThan = 7,
    Equals = 8,
    SetRelativeBase = 9,
    Halt = 99,
}

impl From<u8> for Opcode {
    fn from(byte: u8) -> Self {
        match byte {
            1 => Opcode::Add,
            2 => Opcode::Multiply,
            3 => Opcode::Load,
            4 => Opcode::Output,
            5 => Opcode::JumpIfTrue,
            6 => Opcode::JumpIfFalse,
            7 => Opcode::LessThan,
            8 => Opcode::Equals,
            9 => Opcode::SetRelativeBase,
            99 => Opcode::Halt,
            _ => panic!("{} is not a valid opcode", byte),
        }
    }
}

#[derive(Debug)]
struct Input {
    arg: InstructionArgument,
    value: Option<i64>,
}

#[derive(Debug)]
pub struct Intcode {
    memory: Memory,
    pending_input: Option<Input>,
    pending_output: Option<i64>,
}

impl Intcode {
    pub fn new(program: &[i64]) -> Self {
        Intcode {
            memory: Memory::load_program(program),
            pending_input: None,
            pending_output: None,
        }
    }

    pub fn dump_memory(&self) -> String {
        self.memory.dump()
    }

    pub fn run(&mut self) -> Interrupt {
        loop {
            let instruction = self.memory.get_instruction();
            let call = match instruction {
                Some(code) => self.call(code),
                None => panic!("Address {} does not exist", self.memory.program_counter),
            };
            match call {
                ProgramCounter::Stride(stride) => self.memory.program_counter += stride,
                ProgramCounter::Interrupt(cause) => return cause,
                ProgramCounter::Jump(addr) => self.memory.program_counter = addr,
                ProgramCounter::Halt => return Interrupt::Halted,
            };
        }
    }

    pub fn set_input(&mut self, input: i64) {
        if let Some(pending_input) = self.pending_input.take() {
            self.pending_input = Some(Input {
                arg: pending_input.arg,
                value: Some(input),
            });
        }
    }

    fn get_arg(&self, code: i64, index: usize) -> InstructionArgument {
        let power = (index as u32) + 2;
        let mask = i64::pow(10, power);
        let mode = ((code / mask) % 10) as u8;
        let value = self.memory[self.memory.program_counter + index + 1];
        InstructionArgument::from(mode, value)
    }

    fn call(&mut self, code: i64) -> ProgramCounter {
        let get_two = || (self.get_arg(code, 0), self.get_arg(code, 1));
        let get_three = || {
            (
                self.get_arg(code, 0),
                self.get_arg(code, 1),
                self.get_arg(code, 2),
            )
        };
        let opcode: Opcode = From::from((code % 100) as u8);
        // let args = mem.get_args(code);
        match opcode {
            Opcode::Add => {
                let (augend, addend, sum) = get_three();
                self.add(augend, addend, sum);
                ProgramCounter::Stride(4)
            }
            Opcode::Multiply => {
                let (multiplier, multiplicand, product) = get_three();
                self.mult(multiplier, multiplicand, product);
                ProgramCounter::Stride(4)
            }
            Opcode::Load => match self.pending_input {
                Some(Input {
                    arg,
                    value: Some(input),
                }) => {
                    self.ld(arg, input);
                    self.pending_input = None;
                    ProgramCounter::Stride(2)
                }
                _ => {
                    let arg = self.get_arg(code, 0);
                    self.pending_input = Some(Input { arg, value: None });
                    ProgramCounter::Interrupt(Interrupt::WaitingForInput)
                }
            },
            Opcode::Output => match self.pending_output {
                Some(_) => {
                    self.pending_output = None;
                    ProgramCounter::Stride(2)
                }
                None => {
                    let arg = self.get_arg(code, 0);
                    let output = self.output_arg(arg);
                    self.pending_output = Some(output);
                    ProgramCounter::Interrupt(Interrupt::Output(output))
                }
            },
            Opcode::JumpIfTrue => {
                let (arg0, arg1) = get_two();
                self.jump_if_true(arg0, arg1)
            }
            Opcode::JumpIfFalse => {
                let (arg0, arg1) = get_two();
                self.jump_if_false(arg0, arg1)
            }
            Opcode::LessThan => {
                let (lhs, rhs, addr) = get_three();
                self.less_than(lhs, rhs, addr);
                ProgramCounter::Stride(4)
            }
            Opcode::Equals => {
                let (lhs, rhs, addr) = get_three();
                self.equals(lhs, rhs, addr);
                ProgramCounter::Stride(4)
            }
            Opcode::SetRelativeBase => {
                let arg = self.get_arg(code, 0);
                self.memory
                    .checked_adjust_relative_base(self.memory.get(arg));
                ProgramCounter::Stride(2)
            }
            Opcode::Halt => ProgramCounter::Halt,
        }
    }

    fn add(
        &mut self,
        augend: InstructionArgument,
        addend: InstructionArgument,
        sum: InstructionArgument,
    ) {
        self.memory
            .set(sum, self.memory.get(augend) + self.memory.get(addend));
    }

    fn mult(
        &mut self,
        multiplier: InstructionArgument,
        multiplicand: InstructionArgument,
        product: InstructionArgument,
    ) {
        self.memory.set(
            product,
            self.memory.get(multiplier) * self.memory.get(multiplicand),
        );
    }

    fn ld(&mut self, addr: InstructionArgument, input: i64) {
        self.memory.set(addr, input);
    }

    fn output_arg(&mut self, addr: InstructionArgument) -> i64 {
        self.memory.get(addr)
    }

    fn jump_if_true(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if self.memory.get(arg0) != 0 {
            ProgramCounter::Jump(self.memory.get(arg1) as usize)
        } else {
            ProgramCounter::Stride(3)
        }
    }

    fn jump_if_false(
        &mut self,
        arg0: InstructionArgument,
        arg1: InstructionArgument,
    ) -> ProgramCounter {
        if self.memory.get(arg0) == 0 {
            ProgramCounter::Jump(self.memory.get(arg1) as usize)
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
        if self.memory.get(lhs) < self.memory.get(rhs) {
            self.memory.set(addr, 1);
        } else {
            self.memory.set(addr, 0);
        }
    }

    fn equals(
        &mut self,
        lhs: InstructionArgument,
        rhs: InstructionArgument,
        addr: InstructionArgument,
    ) {
        if self.memory.get(lhs) == self.memory.get(rhs) {
            self.memory.set(addr, 1);
        } else {
            self.memory.set(addr, 0);
        }
    }
}
