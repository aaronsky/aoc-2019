pub struct ElfGame {
    last: String,
}

impl ElfGame {
    pub fn start(start: &str) -> Self {
        ElfGame {
            last: start.to_string(),
        }
    }
}

impl Iterator for ElfGame {
    type Item = String;

    fn next(&mut self) -> Option<Self::Item> {
        let last = self.last.to_string();

        let mut digits = last.chars();
        let mut sequence = vec![];

        let mut last_digit = None;
        let mut digit_count = 1;

        loop {
            match (last_digit, digits.next()) {
                (_, None) => break,
                (Some(ld), Some(digit)) if digit == ld => digit_count += 1,
                (Some(ld), Some(digit)) => {
                    sequence.push(format!("{}{}", digit_count, ld));
                    last_digit = Some(digit);
                    digit_count = 1;
                }
                (None, Some(digit)) => {
                    last_digit = Some(digit);
                    digit_count = 1;
                }
            };
        }

        if let Some(ld) = last_digit {
            sequence.push(format!("{}{}", digit_count, ld));
        }

        self.last = sequence.join("");

        Some(self.last.clone())
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input = util::Input::new("day10.txt", crate::YEAR)
            .unwrap()
            .to_string();
        let mut game = ElfGame::start(&input);

        for _ in 0..39 {
            let _ = game.next().unwrap();
        }
        assert_eq!(game.next().unwrap().len(), 360154);

        for _ in 0..9 {
            let _ = game.next().unwrap();
        }
        assert_eq!(game.next().unwrap().len(), 5103798);
    }

    #[test]
    fn test_simple_example() {
        let input = "1";
        let mut game = ElfGame::start(&input);

        assert_eq!(game.next().unwrap(), "11");
        assert_eq!(game.next().unwrap(), "21");
        assert_eq!(game.next().unwrap(), "1211");
        assert_eq!(game.next().unwrap(), "111221");
        assert_eq!(game.next().unwrap(), "312211");
    }
}
