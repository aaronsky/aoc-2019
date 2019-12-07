#[cfg(test)]
mod tests {
    use crate::intcode::Intcode;
    use crate::utils;

    #[test]
    fn test_advent_puzzle() {
        let mut output = None;
        let rom = utils::load_input_file(
            "day05.txt",
            utils::parse_comma_separated_content_into_vec_of_fromstr_data,
        )
        .unwrap();
        let mut program = Intcode::new(rom, || 5, |o| output = Some(o));
        program.run();
        assert_eq!(output, Some(8805067));
    }
}
