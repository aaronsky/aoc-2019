use std::str::FromStr;

const ROWS: usize = 127;
const COLS: usize = 7;

#[derive(Debug, PartialEq)]
pub struct BoardingPass {
    row: usize,
    col: usize,
}

impl BoardingPass {
    pub fn id(&self) -> usize {
        self.row * 8 + self.col
    }
}

impl FromStr for BoardingPass {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        assert_eq!(s.len(), 10);

        let mut curr_low = 0;
        let mut curr_high = ROWS;

        let mut row = usize::default();
        let mut col = usize::default();

        for (i, c) in s.chars().enumerate() {
            if i == 6 {
                row = if c == 'F' { curr_low } else { curr_high };
                curr_low = 0;
                curr_high = COLS;
            } else if i == 9 {
                col = if c == 'L' { curr_low } else { curr_high };
            } else {
                let half_range = ((curr_high as f32 - curr_low as f32) / 2.0).ceil() as usize;
                let new = match c {
                    // take lower
                    'F' | 'L' => (curr_low, curr_high - half_range),
                    // take upper
                    'B' | 'R' => (curr_low + half_range, curr_high),
                    _ => return Err(()),
                };
                curr_low = new.0;
                curr_high = new.1;
            }
        }

        Ok(BoardingPass { row, col })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let mut passes = util::Input::new("day05.txt", crate::YEAR)
            .unwrap()
            .into_vec::<BoardingPass>("\n");

        assert_eq!(passes.iter().map(BoardingPass::id).max(), Some(822));

        passes.sort_by(|a, b| a.id().partial_cmp(&b.id()).unwrap());
        let my_seat_id = passes
            .iter()
            .zip(passes.iter().skip(1))
            .find(|(before, current)| current.id() - before.id() == 2)
            .map(|(_, current)| current.id() - 1);

        assert_eq!(my_seat_id, Some(705));
    }

    #[test]
    fn test_smoke_test() {
        assert_eq!(
            BoardingPass::from_str("FBFBBFFRLR").unwrap(),
            BoardingPass { row: 44, col: 5 }
        );
        assert_eq!(
            BoardingPass::from_str("BFFFBBFRRR").unwrap(),
            BoardingPass { row: 70, col: 7 }
        );
        assert_eq!(
            BoardingPass::from_str("FFFBBBFRRR").unwrap(),
            BoardingPass { row: 14, col: 7 }
        );
        assert_eq!(
            BoardingPass::from_str("BBFFBBFRLL").unwrap(),
            BoardingPass { row: 102, col: 4 }
        );
    }
}
