#[cfg(test)]
mod tests {
    use crate::shared::Intcode;
    use util;

    #[test]
    fn smoke_simple_program_1() {
        let mut program = Intcode::new(&vec![1, 0, 0, 0, 99]);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert_eq!(
            program.dump_memory(),
            String::from("[2, 0, 0, 0, 99, 0, 0, 0, 0, 0]")
        );
    }

    #[test]
    fn smoke_simple_program_2() {
        let mut program = Intcode::new(&vec![2, 3, 0, 3, 99]);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert_eq!(
            program.dump_memory(),
            String::from("[2, 3, 0, 6, 99, 0, 0, 0, 0, 0]")
        );
    }

    #[test]
    fn smoke_simple_program_3() {
        let mut program = Intcode::new(&vec![2, 4, 4, 5, 99, 0]);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert_eq!(
            program.dump_memory(),
            String::from("[2, 4, 4, 5, 99, 9801, 0, 0, 0, 0, 0, 0]")
        );
    }

    #[test]
    fn smoke_simple_program_4() {
        let mut program = Intcode::new(&vec![1, 1, 1, 4, 99, 5, 6, 0, 99]);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert_eq!(
            program.dump_memory(),
            String::from("[30, 1, 1, 4, 2, 5, 6, 0, 99, 0, 0, 0, 0, 0, 0, 0, 0, 0]")
        );
    }

    #[test]
    fn test_advent_puzzle() {
        let rom = util::Input::new("day02.txt", crate::YEAR)
            .unwrap()
            .to_vec(",");
        let mut program = Intcode::new(&rom);
        loop {
            match program.run() {
                _ => break,
            }
        }
        assert!(program.dump_memory().starts_with("[12490719,"));
    }
}
