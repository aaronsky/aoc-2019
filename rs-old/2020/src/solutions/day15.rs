use std::collections::HashMap;

pub struct ElfGame;

impl ElfGame {
    pub fn play(starting_numbers: &[u32], times: u32) -> u32 {
        let mut turns_spoken = HashMap::with_capacity(100_000);
        let mut turn = 0;
        let mut last_spoken = 0;

        for n in starting_numbers {
            turn += 1;
            turns_spoken.insert(*n, (turn, None));
            last_spoken = *n;
        }

        while turn < times {
            turn += 1;

            last_spoken = match turns_spoken.get(&last_spoken) {
                Some((last, Some(last_last))) => last - last_last,
                _ => 0,
            };

            turns_spoken.insert(
                last_spoken,
                (turn, turns_spoken.get(&last_spoken).map(|(t, _)| *t)),
            );
        }

        last_spoken
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input = util::Input::new("day15.txt", crate::YEAR)
            .unwrap()
            .into_vec(",");
        assert_eq!(ElfGame::play(&input, 2020), 1259);
        // FIXME: This is slow :(
        // assert_eq!(ElfGame::play(&input, 30_000_000), 689);
    }
}
