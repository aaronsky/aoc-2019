use std::collections::HashSet;

pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

impl Direction {
    fn offset(&self) -> (i32, i32) {
        match self {
            Direction::Up => (0, -1),
            Direction::Down => (0, 1),
            Direction::Left => (-1, 0),
            Direction::Right => (1, 0),
        }
    }
}

impl From<char> for Direction {
    fn from(c: char) -> Self {
        match c {
            '^' => Direction::Up,
            'v' => Direction::Down,
            '<' => Direction::Left,
            '>' => Direction::Right,
            _ => unreachable!("impossible value"),
        }
    }
}

pub fn unique_houses_receiving_presents(instructions: &[Direction]) -> usize {
    let mut current_position = (0, 0);
    let mut houses = HashSet::new();

    houses.insert(current_position);

    for d in instructions {
        let offset = d.offset();

        current_position.0 += offset.0;
        current_position.1 += offset.1;

        houses.insert(current_position);
    }

    houses.len()
}

pub fn unique_houses_receiving_presents_two_workers(instructions: &[Direction]) -> usize {
    let mut current_santa = (0, 0);
    let mut current_robo = (0, 0);
    let mut tracking_robo = false;

    let mut houses = HashSet::new();

    houses.insert(current_santa);
    houses.insert(current_robo);

    for d in instructions {
        let offset = d.offset();

        if tracking_robo {
            current_robo.0 += offset.0;
            current_robo.1 += offset.1;

            houses.insert(current_robo);
            tracking_robo = false;
        } else {
            current_santa.0 += offset.0;
            current_santa.1 += offset.1;

            houses.insert(current_santa);
            tracking_robo = true;
        }
    }

    houses.len()
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let instructions: Vec<Direction> = util::load_input_file("day03.txt", crate::YEAR)
            .unwrap()
            .into_raw()
            .chars()
            .map(Direction::from)
            .collect();

        let num_houses = unique_houses_receiving_presents(&instructions);
        assert_eq!(num_houses, 2592);

        let num_houses_robo = unique_houses_receiving_presents_two_workers(&instructions);
        assert_eq!(num_houses_robo, 2360);
    }
}
