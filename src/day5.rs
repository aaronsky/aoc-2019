use digits_iterator::*;

#[allow(dead_code)]
type Memory = Vec<i32>;

#[allow(dead_code)]
struct Rom;

#[allow(dead_code)]
impl Rom {
    fn from_str(input: &str) -> Memory {
        input.split(",").map(Rom::str_to_i32).collect()
    }

    fn str_to_i32(string: &str) -> i32 {
        string.parse::<i32>().unwrap()
    }
}

#[allow(dead_code)]
#[derive(Debug)]
enum InstructionArgument {
    Position(usize),
    Immediate(i32),
}

#[allow(dead_code)]
impl InstructionArgument {
    fn get(&self, mem: &Memory) -> i32 {
        match *self {
            InstructionArgument::Position(pos) => mem[pos],
            InstructionArgument::Immediate(value) => value,
        }
    }
}

#[allow(dead_code)]
enum ProgramCounter {
    Stride(usize),
    Halt,
    Jump(usize),
}

#[allow(dead_code)]
struct Cpu<I, O> {
    pub mem: Memory,
    pub pc: usize,
    input: I,
    output: O,
}

#[allow(dead_code)]
impl<I, O> Cpu<I, O>
where
    I: FnMut() -> i32,
    O: FnMut(i32),
{
    fn new(mem: Memory, input: I, output: O) -> Self {
        Cpu {
            mem,
            pc: 0,
            input,
            output,
        }
    }

    fn run(&mut self) {
        loop {
            let instruction = self.mem.get(self.pc).cloned();
            let call = match instruction {
                Some(code) => self.call(code),
                None => panic!("Address {} does not exist", self.pc),
            };
            match call {
                ProgramCounter::Stride(stride) => self.pc += stride,
                ProgramCounter::Jump(addr) => self.pc = addr,
                ProgramCounter::Halt => break,
            };
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
                self.ld(arg.unwrap());
                ProgramCounter::Stride(2)
            }
            4 => {
                let (arg, _, _) = args;
                self.output_arg(arg.unwrap());
                ProgramCounter::Stride(2)
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
        let arg0 = args.pop();
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

    fn ld(&mut self, addr: InstructionArgument) {
        if let InstructionArgument::Position(addr_pos) = addr {
            self.mem[addr_pos] = (self.input)();
        } else {
            panic!("Immediate mode is not supported for ld");
        }
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

    fn output_arg(&mut self, addr: InstructionArgument) {
        (self.output)(addr.get(&self.mem))
    }

    fn dump_memory(&self) -> String {
        format!("{:?}", self.mem)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_advent_puzzle() {
        let mut output = None;
        let mut program = Cpu::new(Rom::from_str("3,225,1,225,6,6,1100,1,238,225,104,0,1101,82,10,225,\
        101,94,44,224,101,-165,224,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,1102,35,77,225,\
        1102,28,71,225,1102,16,36,225,102,51,196,224,101,-3468,224,224,4,224,102,8,223,223,1001,224,7,\
        224,1,223,224,223,1001,48,21,224,101,-57,224,224,4,224,1002,223,8,223,101,6,224,224,1,223,224,\
        223,2,188,40,224,1001,224,-5390,224,4,224,1002,223,8,223,101,2,224,224,1,224,223,223,1101,9,\
        32,224,101,-41,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1102,66,70,225,1002,\
        191,28,224,101,-868,224,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1,14,140,224,101,\
        -80,224,224,4,224,1002,223,8,223,101,2,224,224,1,224,223,223,1102,79,70,225,1101,31,65,225,1101,\
        11,68,225,1102,20,32,224,101,-640,224,224,4,224,1002,223,8,223,1001,224,5,224,1,224,223,223,4,\
        223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,\
        1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,\
        99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,\
        99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,8,226,226,224,1002,223,2,223,1006,224,329,\
        101,1,223,223,1008,677,677,224,102,2,223,223,1006,224,344,101,1,223,223,1107,226,677,224,102,2,\
        223,223,1005,224,359,101,1,223,223,1008,226,226,224,1002,223,2,223,1006,224,374,1001,223,1,223,\
        1108,677,226,224,1002,223,2,223,1006,224,389,1001,223,1,223,7,677,226,224,1002,223,2,223,1006,\
        224,404,101,1,223,223,7,226,226,224,1002,223,2,223,1005,224,419,101,1,223,223,8,226,677,224,1002,\
        223,2,223,1006,224,434,1001,223,1,223,7,226,677,224,1002,223,2,223,1006,224,449,1001,223,1,223,\
        107,226,677,224,1002,223,2,223,1005,224,464,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,\
        224,479,101,1,223,223,1007,226,226,224,102,2,223,223,1005,224,494,1001,223,1,223,1108,226,677,224,\
        102,2,223,223,1005,224,509,101,1,223,223,1008,677,226,224,102,2,223,223,1005,224,524,1001,223,1,223,\
        1007,677,226,224,102,2,223,223,1005,224,539,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,\
        554,101,1,223,223,108,226,226,224,102,2,223,223,1005,224,569,101,1,223,223,108,677,677,224,102,2,\
        223,223,1005,224,584,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,599,101,1,223,223,8,677,\
        226,224,1002,223,2,223,1006,224,614,1001,223,1,223,108,677,226,224,102,2,223,223,1006,224,629,1001,\
        223,1,223,1107,677,226,224,1002,223,2,223,1006,224,644,1001,223,1,223,107,677,677,224,102,2,223,223,\
        1005,224,659,101,1,223,223,107,226,226,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226"),
            || 5,
            |o| output = Some(o));
        program.run();
        println!("{:?}", output);
    }
}
