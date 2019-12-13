#[cfg(test)]
mod tests {
    use crate::intcode::{Intcode, Interrupt};
    use crate::util;
    use crate::util::ListInput;

    #[test]
    fn test_advent_puzzle_1() {
        let mut output = None;
        let ListInput(rom) = util::load_input_file("day09.txt").unwrap();
        let mut program = Intcode::new(&rom);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => program.set_input(1),
                Interrupt::Output(o) => output = Some(o),
                _ => break,
            }
        }
        program.run();
        assert_eq!(output, Some(3765554916));
    }

    #[test]
    fn test_advent_puzzle_2() {
        let mut output = None;
        let ListInput(rom) = util::load_input_file("day09.txt").unwrap();
        let mut program = Intcode::new(&rom);
        loop {
            match program.run() {
                Interrupt::WaitingForInput => program.set_input(2),
                Interrupt::Output(o) => output = Some(o),
                _ => break,
            }
        }
        program.run();
        assert_eq!(output, Some(76642));
    }

    #[test]
    fn smoke_simple_program_1() {
        let mut program = Intcode::new(&vec![
            109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99,
        ]);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert_eq!(
            program.dump_memory(),
            String::from(
                "[109, 1, 204, -1, 1001, 100, 1, 100, 1008, 100, 16, 101, 1006, 101, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]"
            )
        );
    }

    #[test]
    fn smoke_simple_program_2() {
        let mut output = None;
        let mut program = Intcode::new(&vec![1102, 34915192, 34915192, 7, 4, 7, 99, 0]);
        loop {
            match program.run() {
                Interrupt::Output(o) => output = Some(o),
                Interrupt::WaitingForInput => program.set_input(5),
                _ => break,
            }
        }
        program.run();
        assert_eq!(
            output.map(|o| util::number_of_digits(o as f64) as i64),
            Some(16)
        );
    }

    #[test]
    fn smoke_simple_program_3() {
        let mut output = None;
        let mut program = Intcode::new(&vec![104, 1125899906842624, 99]);
        loop {
            match program.run() {
                Interrupt::Output(o) => output = Some(o),
                Interrupt::WaitingForInput => program.set_input(5),
                _ => break,
            }
        }
        program.run();
        assert_eq!(output, Some(1125899906842624));
    }
}
