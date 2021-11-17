use std::{collections::HashSet, num::ParseIntError, str::FromStr};

#[derive(Debug, PartialEq, Eq, Copy, Clone)]
pub enum Instruction {
    Acc(i32),
    Jmp(i32),
    Noop(i32),
}

#[derive(Debug)]
pub struct Program {
    rom: Rom,
    accumulator: i32,
    counter: usize,
}

impl Program {
    pub fn load(rom: Rom) -> Self {
        Program {
            rom,
            accumulator: 0,
            counter: 0,
        }
    }

    pub fn run(&mut self) -> Result<(), ()> {
        loop {
            if !self.rom.mark_instruction_run(self.counter) {
                return Err(());
            }

            let instruction = self.rom.instructions.get(self.counter);

            match instruction {
                Some(Instruction::Acc(val)) => {
                    self.accumulator += val;
                    self.counter += 1;
                }
                Some(Instruction::Jmp(offset)) => self.counter = self.jump_index(*offset),
                Some(Instruction::Noop(_)) => {
                    self.counter += 1;
                }
                None => break,
            };
        }

        Ok(())
    }

    fn jump_index(&self, offset: i32) -> usize {
        let counter = self.counter;
        if offset.is_negative() {
            counter.saturating_sub(offset.wrapping_abs() as u32 as usize)
        } else {
            counter.saturating_add(offset as usize)
        }
    }
}

#[derive(Debug)]
pub struct Rom {
    instructions: Vec<Instruction>,
    visited: HashSet<usize>,
}

impl Rom {
    /// If the instruction has run before, this function does not update the hash and returns false.
    /// Otherwise, it will insert the index into the hash and return true if written successfully.
    pub fn mark_instruction_run(&mut self, index: usize) -> bool {
        self.visited.insert(index)
    }

    pub fn len(&self) -> usize {
        self.instructions.len()
    }

    pub fn is_empty(&self) -> bool {
        self.instructions.is_empty()
    }
}

impl FromStr for Rom {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let instructions = s
            .lines()
            .map(|l| l.split(' ').take(2).collect::<Vec<_>>())
            .map(|comps| -> Result<(&str, i32), ParseIntError> {
                let num = i32::from_str(comps[1])?;
                Ok((comps[0], num))
            })
            .filter_map(Result::ok)
            .map(|i| match i {
                ("acc", val) => Instruction::Acc(val),
                ("jmp", val) => Instruction::Jmp(val),
                ("nop", val) => Instruction::Noop(val),
                _ => unreachable!("impossible value"),
            })
            .collect::<Vec<_>>();
        let size = instructions.len();

        Ok(Self {
            instructions,
            visited: HashSet::with_capacity(size),
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    fn load_input() -> Rom {
        util::Input::new("day08.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap()
    }

    #[test]
    fn test_advent_puzzle_one() {
        let rom = load_input();
        let mut program = Program::load(rom);

        assert!(program.run().is_err());
        assert_eq!(program.accumulator, 1614);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let index_that_fixes_boot_loader = 247;
        let mut rom = load_input();

        if let Instruction::Jmp(val) = rom.instructions[index_that_fixes_boot_loader] {
            rom.instructions[index_that_fixes_boot_loader] = Instruction::Noop(val);
        }

        let mut program = Program::load(rom);

        assert!(program.run().is_ok());
        assert_eq!(program.accumulator, 1260);
    }
}
