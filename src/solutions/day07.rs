use crate::intcode::{Intcode, Interrupt};
use std::collections::{HashSet, VecDeque};
use std::iter::FromIterator;

pub fn output_for_amplifier_looping(rom: &[i64], amplifier_sequence: &[i64]) -> i64 {
    let mut programs = vec![
        Intcode::new(&rom.clone()),
        Intcode::new(&rom.clone()),
        Intcode::new(&rom.clone()),
        Intcode::new(&rom.clone()),
        Intcode::new(&rom.clone()),
    ];

    for i in 0..5 {
        let program = &mut programs[i];
        program.run();
        program.set_input(amplifier_sequence[i]);
        program.run();
    }

    let mut output = 0;

    loop {
        let mut halted = false;
        for program in &mut programs {
            program.set_input(output);
            match program.run() {
                Interrupt::WaitingForInput => continue,
                Interrupt::Output(o) => output = o,
                Interrupt::Halted => halted = true,
            }
        }
        if halted {
            break;
        }
    }

    output
}

pub fn output_for_amplifier_sequence(rom: &[i64], amplifier_sequence: &[i64]) -> i64 {
    let mut last_output = 0;
    for code in amplifier_sequence {
        let mut has_provided_first_input = false;
        let mut output = 0;
        let mut program = Intcode::new(rom);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => match (last_output, has_provided_first_input) {
                    (last, true) => program.set_input(last),
                    (_, false) => {
                        has_provided_first_input = true;
                        program.set_input(*code)
                    }
                },
                Interrupt::Output(o) => output = o,
                _ => break,
            }
        }
        last_output = output;
    }
    last_output
}

pub struct AmplifierSequence;

impl AmplifierSequence {
    pub fn permutations(possible_numbers: HashSet<i64>) -> Vec<Vec<i64>> {
        let mut permutations = vec![];
        let mut queue = VecDeque::from_iter(possible_numbers.into_iter());
        AmplifierSequence::permute(&mut vec![], &mut queue, &mut permutations);
        permutations
    }

    fn permute(used: &mut Vec<i64>, unused: &mut VecDeque<i64>, output: &mut Vec<Vec<i64>>) {
        if unused.is_empty() {
            output.push(used.clone());
            return;
        }
        for _ in 0..unused.len() {
            used.push(unused.pop_front().unwrap());
            AmplifierSequence::permute(used, unused, output);
            unused.push_back(used.pop().unwrap());
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::util;
    use crate::util::ListInput;

    #[test]
    fn test_advent_puzzle_1() {
        let mut possible_numbers = HashSet::new();
        possible_numbers.insert(0);
        possible_numbers.insert(1);
        possible_numbers.insert(2);
        possible_numbers.insert(3);
        possible_numbers.insert(4);
        let ListInput(rom) = util::load_input_file("day07.txt").unwrap();
        let max_output = AmplifierSequence::permutations(possible_numbers)
            .iter()
            .map(|seq| output_for_amplifier_sequence(&rom, &seq))
            .max();
        assert_eq!(max_output, Some(273814));
    }

    #[test]
    fn test_advent_puzzle_2() {
        let mut possible_numbers = HashSet::new();
        possible_numbers.insert(5);
        possible_numbers.insert(6);
        possible_numbers.insert(7);
        possible_numbers.insert(8);
        possible_numbers.insert(9);
        let ListInput(rom) = util::load_input_file("day07.txt").unwrap();
        let max_output = AmplifierSequence::permutations(possible_numbers)
            .iter()
            .map(|seq| output_for_amplifier_looping(&rom, &seq))
            .max();
        assert_eq!(max_output, Some(34579864));
    }

    #[test]
    fn smoke_simple_program_1_1() {
        let rom = vec![
            3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0,
        ];
        let amplifier_sequence = vec![4, 3, 2, 1, 0];
        let output = output_for_amplifier_sequence(&rom, &amplifier_sequence);
        assert_eq!(output, 43210);
    }

    #[test]
    fn smoke_simple_program_1_2() {
        let rom = vec![
            3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23, 101, 5, 23, 23, 1, 24, 23, 23, 4, 23,
            99, 0, 0,
        ];
        let amplifier_sequence = vec![0, 1, 2, 3, 4];
        let output = output_for_amplifier_sequence(&rom, &amplifier_sequence);
        assert_eq!(output, 54321);
    }

    #[test]
    fn smoke_simple_program_1_3() {
        let rom = vec![
            3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33, 1002, 33, 7, 33, 1,
            33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0,
        ];
        let amplifier_sequence = vec![1, 0, 4, 3, 2];
        let output = output_for_amplifier_sequence(&rom, &amplifier_sequence);
        assert_eq!(output, 65210);
    }

    #[test]
    fn smoke_simple_program_2_1() {
        let rom = vec![
            3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26, 27, 4, 27, 1001, 28, -1,
            28, 1005, 28, 6, 99, 0, 0, 5,
        ];
        let amplifier_sequence = vec![9, 8, 7, 6, 5];
        let output = output_for_amplifier_looping(&rom, &amplifier_sequence);
        assert_eq!(output, 139629729);
    }

    #[test]
    fn smoke_simple_program_2_2() {
        let rom = vec![
            3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54,
            -5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4,
            53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10,
        ];
        let amplifier_sequence = vec![9, 7, 8, 5, 6];
        let output = output_for_amplifier_looping(&rom, &amplifier_sequence);
        assert_eq!(output, 18216);
    }
}
