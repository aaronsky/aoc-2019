#[cfg(test)]
mod tests {
    use crate::intcode::{Intcode, Interrupt};
    use crate::util;
    use crate::util::ListInput;

    #[test]
    fn test_advent_puzzle() {
        let mut output = None;
        let ListInput(rom) = util::load_input_file("day05.txt").unwrap();
        let mut program = Intcode::new(&rom);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => program.set_input(5),
                Interrupt::Output(o) => output = Some(o),
                _ => break,
            }
        }
        program.run();
        assert_eq!(output, Some(8805067));
    }
}
