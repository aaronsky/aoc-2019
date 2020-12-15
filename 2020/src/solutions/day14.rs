use itertools::Itertools;
use std::{collections::HashMap, num::ParseIntError, str::FromStr};

#[derive(Debug, Clone)]
enum Instruction {
    Mask(String),
    Mem { addr: u64, value: u64 },
}

#[derive(Debug)]
enum InstructionError {
    InvalidInput,
    ParseIntError(ParseIntError),
}

impl FromStr for Instruction {
    type Err = InstructionError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let (head, val_raw) = s
            .splitn(2, " = ")
            .collect_tuple::<(&str, &str)>()
            .ok_or(Self::Err::InvalidInput)?;
        if head.starts_with("mask") {
            Ok(Self::Mask(val_raw.to_string()))
        } else if head.starts_with("mem[") && head.ends_with(']') {
            let addr_raw = head
                .strip_prefix("mem[")
                .ok_or(Self::Err::InvalidInput)?
                .strip_suffix("]")
                .ok_or(Self::Err::InvalidInput)?;
            let addr = u64::from_str(addr_raw).map_err(Self::Err::ParseIntError)?;
            let value = u64::from_str(val_raw).map_err(Self::Err::ParseIntError)?;
            Ok(Instruction::Mem { addr, value })
        } else {
            Err(Self::Err::InvalidInput)
        }
    }
}

#[derive(Debug)]
pub struct ShipNav {
    mem: HashMap<u64, u64>,
    instructions: Vec<Instruction>,
}

impl ShipNav {
    pub fn initialize_memory(&mut self) {
        let mut mask = String::new();
        for instruction in &self.instructions {
            match instruction {
                Instruction::Mask(m) => mask = m.to_owned(),
                Instruction::Mem { addr, value } => {
                    let mut value = *value;
                    for (i, c) in mask.as_bytes().iter().rev().enumerate() {
                        match c {
                            b'0' => value &= !(1 << i),
                            b'1' => value |= 1 << i,
                            _ => {}
                        }
                    }
                    self.mem.insert(*addr, value);
                }
            }
        }
    }

    pub fn initialize_memory_v2(&mut self) {
        fn write(mem: &mut HashMap<u64, u64>, addr: u64, val: u64, mask: &[u8], i: usize) {
            if i > 35 {
                mem.insert(addr, val);
                return;
            }

            let bit = 1 << (35 - i);
            match mask.get(i) {
                Some(b'0') => write(mem, addr, val, mask, i + 1),
                Some(b'1') => write(mem, addr | bit, val, mask, i + 1),
                Some(b'X') => {
                    write(mem, addr, val, mask, i + 1);
                    write(mem, addr ^ bit, val, mask, i + 1);
                }
                _ => {}
            }
        }

        let mut mask = String::new();
        for instruction in &self.instructions {
            match instruction {
                Instruction::Mask(m) => mask = m.to_owned(),
                Instruction::Mem { addr, value } => {
                    write(&mut self.mem, *addr, *value, mask.as_bytes(), 0)
                }
            }
        }
    }
}

impl FromStr for ShipNav {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let instructions = s
            .lines()
            .map(Instruction::from_str)
            .filter_map(Result::ok)
            .collect::<Vec<_>>();
        Ok(Self {
            mem: HashMap::new(),
            instructions,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_simple_program_one() {
        let mut input = ShipNav::from_str(
            "mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0",
        )
        .unwrap();
        input.initialize_memory();
        assert_eq!(input.mem.values().sum::<u64>(), 165);
    }

    #[test]
    fn test_advent_puzzle_one() {
        let mut input: ShipNav = util::Input::new("day14.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        input.initialize_memory();
        assert_eq!(input.mem.values().sum::<u64>(), 10717676595607);
    }

    #[test]
    fn test_simple_program_two() {
        let mut input = ShipNav::from_str(
            "mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1",
        )
        .unwrap();
        input.initialize_memory_v2();
        assert_eq!(input.mem.values().sum::<u64>(), 208);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let mut input: ShipNav = util::Input::new("day14.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        input.initialize_memory_v2();
        assert_eq!(input.mem.values().sum::<u64>(), 3974538275659);
    }
}
