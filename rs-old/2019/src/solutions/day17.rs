#[cfg(test)]
mod tests {
    // use super::*;
    use crate::shared::{Intcode, Interrupt};
    use util;

    #[test]
    #[ignore]
    fn test_advent_puzzle_1() {
        let rom = util::Input::new("day17.txt", crate::YEAR)
            .unwrap()
            .into_vec(",");
        let mut program = Intcode::new(&rom);
        let mut buffer = String::new();
        loop {
            match program.run() {
                Interrupt::WaitingForInput => break,
                Interrupt::Output(o) => {
                    let new_char = match o {
                        35 => '#',
                        46 => '.',
                        10 => '\n',
                        _ => continue,
                    };
                    buffer.push(new_char);
                }
                Interrupt::Halted => break,
            }
        }
        println!("{}", buffer);
    }
}
