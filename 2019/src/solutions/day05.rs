#[cfg(test)]
mod tests {
    use crate::shared::{Intcode, Interrupt};
    use util;

    #[test]
    fn test_advent_puzzle() {
        let mut output = None;
        let rom = util::Input::new("day05.txt", crate::YEAR)
            .unwrap()
            .to_vec(",");
        let mut program = Intcode::new(&rom);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => program.set_input(5),
                Interrupt::Output(o) => output = Some(o),
                _ => break,
            }
        }
        assert_eq!(output, Some(8805067));
    }
}
