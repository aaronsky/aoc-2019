use crate::intcode::Intcode;
use crate::utils;
use std::collections::{HashSet, VecDeque};
use std::iter::FromIterator;

// fn amplifier(rom: &str, amplifier_sequence: &[i32]) -> Option<i32> {
//     let instructions: Vec<i32> = utils::parse_comma_separated_content_into_vec_of_fromstr_data(rom);

//     let mut current_program_index = 0;
//     let mut has_supplied_initial_data = false;
//     let mut has_supplied_sequence_data = vec![false, false, false, false, false];
//     let mut program_output: Vec<Option<i32>> = vec![None, None, None, None, None];
//     let mut programA = Intcode::new(
//         instructions.clone(),
//         || {
//             // get 0, sequence code, or output E
//             if !has_supplied_initial_data {
//                 has_supplied_initial_data = true;
//                 0
//             } else if !has_supplied_sequence_data[current_program_index] {
//                 has_supplied_sequence_data[current_program_index] = true;
//                 amplifier_sequence[current_program_index]
//             } else if let Some(output) = program_output.get(4).and_then(|o| o.as_ref()) {
//                 *output
//             } else {
//                 panic!("Insufficient data available to continue program A");
//             }
//         },
//         |o| {
//             // send to input B
//         },
//     );
//     let mut programB = Intcode::new(
//         instructions.clone(),
//         || {
//             // get sequence code, or output A
//             if !has_supplied_sequence_data[current_program_index] {
//                 has_supplied_sequence_data[current_program_index] = true;
//                 amplifier_sequence[current_program_index]
//             } else if let Some(output) = program_output.get(0).and_then(|o| o.as_ref()) {
//                 *output
//             } else {
//                 panic!("Insufficient data available to continue program A");
//             }
//         },
//         |o| {
//             // send to input C
//         },
//     );
//     let mut programC = Intcode::new(
//         instructions.clone(),
//         || {
//             // get sequence code, or output B
//             if !has_supplied_sequence_data[current_program_index] {
//                 has_supplied_sequence_data[current_program_index] = true;
//                 amplifier_sequence[current_program_index]
//             } else if let Some(output) = program_output.get(1).and_then(|o| o.as_ref()) {
//                 *output
//             } else {
//                 panic!("Insufficient data available to continue program A");
//             }
//         },
//         |o| {
//             // send to input D
//         },
//     );
//     let mut programD = Intcode::new(
//         instructions.clone(),
//         || {
//             // get sequence code, or output C
//             if !has_supplied_sequence_data[current_program_index] {
//                 has_supplied_sequence_data[current_program_index] = true;
//                 amplifier_sequence[current_program_index]
//             } else if let Some(output) = program_output.get(2).and_then(|o| o.as_ref()) {
//                 *output
//             } else {
//                 panic!("Insufficient data available to continue program A");
//             }
//         },
//         |o| {
//             // send to input E
//         },
//     );
//     let mut programE = Intcode::new(
//         instructions.clone(),
//         || {
//             // get sequence code, or output D
//             if !has_supplied_sequence_data[current_program_index] {
//                 has_supplied_sequence_data[current_program_index] = true;
//                 amplifier_sequence[current_program_index]
//             } else if let Some(output) = program_output.get(3).and_then(|o| o.as_ref()) {
//                 *output
//             } else {
//                 panic!("Insufficient data available to continue program A");
//             }
//         },
//         |o| {
//             // send to input A
//         },
//     );

//     programA.run();

//     None
// }

pub fn output_for_amplifier_sequence(rom: &str, amplifier_sequence: &[i32]) -> Option<i32> {
    let mut last_output = None;
    for i in 0..5 {
        let mut has_provided_first_input = false;
        let mut output = None;
        Intcode::new(
            utils::parse_comma_separated_content_into_vec_of_fromstr_data(rom),
            || match (last_output, has_provided_first_input) {
                (Some(last), true) => last,
                (_, true) => 0,
                (_, false) => {
                    has_provided_first_input = true;
                    amplifier_sequence[i]
                }
            },
            |o| output = Some(o),
        )
        .run();
        last_output = output;
    }
    last_output
}

pub struct AmplifierSequence;

impl AmplifierSequence {
    pub fn permutations(possible_numbers: HashSet<i32>) -> Vec<Vec<i32>> {
        let mut permutations = vec![];
        let mut queue = VecDeque::from_iter(possible_numbers.into_iter());
        AmplifierSequence::permute(&mut vec![], &mut queue, &mut permutations);
        permutations
    }

    fn permute(used: &mut Vec<i32>, unused: &mut VecDeque<i32>, output: &mut Vec<Vec<i32>>) {
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

    #[test]
    fn test_advent_puzzle() {
        let mut possible_numbers = HashSet::new();
        possible_numbers.insert(0);
        possible_numbers.insert(1);
        possible_numbers.insert(2);
        possible_numbers.insert(3);
        possible_numbers.insert(4);
        let rom = utils::load_input_file("day07.txt", str::to_string).unwrap();
        let max_output = AmplifierSequence::permutations(possible_numbers)
            .iter()
            .map(|seq| output_for_amplifier_sequence(&rom, &seq))
            .filter_map(|o| o)
            .max();
        assert_eq!(max_output, Some(273814));
    }

    #[test]
    fn smoke_simple_program_1() {
        let rom = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0";
        let amplifier_sequence = vec![4, 3, 2, 1, 0];
        let output = output_for_amplifier_sequence(rom, &amplifier_sequence);
        assert_eq!(output, Some(43210));
    }

    #[test]
    fn smoke_simple_program_2() {
        let rom = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0";
        let amplifier_sequence = vec![0, 1, 2, 3, 4];
        let output = output_for_amplifier_sequence(rom, &amplifier_sequence);
        assert_eq!(output, Some(54321));
    }

    #[test]
    fn smoke_simple_program_3() {
        let rom = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0";
        let amplifier_sequence = vec![1, 0, 4, 3, 2];
        let output = output_for_amplifier_sequence(rom, &amplifier_sequence);
        assert_eq!(output, Some(65210));
    }
}
