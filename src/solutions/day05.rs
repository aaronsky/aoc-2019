#[cfg(test)]
mod tests {
    use crate::intcode::{ExecutionState, Intcode};
    use crate::utils;

    #[test]
    fn test_advent_puzzle() {
        let mut output = None;
        let rom = utils::load_input_file(
            "day05.txt",
            utils::parse_comma_separated_content_into_vec_of_fromstr_data,
        )
        .unwrap();
        let mut program = Intcode::new(rom);
        loop {
            match program.run() {
                ExecutionState::Output(o) => output = Some(o),
                ExecutionState::WaitingForInput => program.set_input(5),
                _ => break,
            }
        }
        program.run();
        assert_eq!(output, Some(8805067));
    }
}
