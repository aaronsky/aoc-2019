#[allow(dead_code)]
type Memory = Vec<u32>;

#[allow(dead_code)]
enum CpuCall {
    Stride(usize),
    Halt,
}

#[allow(dead_code)]
struct Cpu {
    mem: Memory,
}

#[allow(dead_code)]
impl Cpu {
    fn new(mem: Memory) -> Self {
        Cpu { mem }
    }

    fn run(&mut self) {
        let mut pointer: usize = 0;
        loop {
            let instruction = self.mem.get(pointer).cloned();
            let call = match instruction {
                Some(code) => self.call(code, &pointer),
                None => panic!("Address {} does not exist", pointer),
            };
            match call {
                CpuCall::Stride(stride) => pointer += stride,
                CpuCall::Halt => break,
            };
        }
    }

    fn call(&mut self, code: u32, instruction_pointer: &usize) -> CpuCall {
        match code {
            1 => {
                self.add_at(instruction_pointer);
                CpuCall::Stride(4)
            }
            2 => {
                self.mult_at(instruction_pointer);
                CpuCall::Stride(4)
            }
            99 => CpuCall::Halt,
            _ => panic!("opcode {:?} is not supported", instruction_pointer),
        }
    }

    fn add_at(&mut self, instruction_pointer: &usize) {
        assert!(self.mem.len() >= instruction_pointer + 3);
        let left_position = self.mem[instruction_pointer + 1] as usize;
        let right_position = self.mem[instruction_pointer + 2] as usize;
        let sum_position = self.mem[instruction_pointer + 3] as usize;
        self.mem[sum_position] = self.mem[left_position] + self.mem[right_position];
    }

    fn mult_at(&mut self, instruction_pointer: &usize) {
        assert!(self.mem.len() >= instruction_pointer + 3);
        let left_position = self.mem[instruction_pointer + 1] as usize;
        let right_position = self.mem[instruction_pointer + 2] as usize;
        let sum_position = self.mem[instruction_pointer + 3] as usize;
        self.mem[sum_position] = self.mem[left_position] * self.mem[right_position];
    }

    fn dump_memory(&self) -> String {
        format!("{:?}", self.mem)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn smoke_simple_program_1() {
        let mut program = Cpu::new(vec![1, 0, 0, 0, 99]);
        program.run();
        assert_eq!(program.dump_memory(), String::from("[2, 0, 0, 0, 99]"));
    }

    #[test]
    fn smoke_simple_program_2() {
        let mut program = Cpu::new(vec![2, 3, 0, 3, 99]);
        program.run();
        assert_eq!(program.dump_memory(), String::from("[2, 3, 0, 6, 99]"));
    }

    #[test]
    fn smoke_simple_program_3() {
        let mut program = Cpu::new(vec![2, 4, 4, 5, 99, 0]);
        program.run();
        assert_eq!(
            program.dump_memory(),
            String::from("[2, 4, 4, 5, 99, 9801]")
        );
    }

    #[test]
    fn smoke_simple_program_4() {
        let mut program = Cpu::new(vec![1, 1, 1, 4, 99, 5, 6, 0, 99]);
        program.run();
        assert_eq!(
            program.dump_memory(),
            String::from("[30, 1, 1, 4, 2, 5, 6, 0, 99]")
        );
    }

    #[test]
    fn test_advent_puzzle() {
        let mut program = Cpu::new(vec![
            1, 12, 2, 3, 1, 1, 2, 3, 1, 3, 4, 3, 1, 5, 0, 3, 2, 13, 1, 19, 1, 19, 6, 23, 1, 23, 6,
            27, 1, 13, 27, 31, 2, 13, 31, 35, 1, 5, 35, 39, 2, 39, 13, 43, 1, 10, 43, 47, 2, 13,
            47, 51, 1, 6, 51, 55, 2, 55, 13, 59, 1, 59, 10, 63, 1, 63, 10, 67, 2, 10, 67, 71, 1, 6,
            71, 75, 1, 10, 75, 79, 1, 79, 9, 83, 2, 83, 6, 87, 2, 87, 9, 91, 1, 5, 91, 95, 1, 6,
            95, 99, 1, 99, 9, 103, 2, 10, 103, 107, 1, 107, 6, 111, 2, 9, 111, 115, 1, 5, 115, 119,
            1, 10, 119, 123, 1, 2, 123, 127, 1, 127, 6, 0, 99, 2, 14, 0, 0,
        ]);
        program.run();
        assert!(program.dump_memory().starts_with("[12490719,"));
    }
}
