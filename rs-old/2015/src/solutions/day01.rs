pub fn get_floor_number(pattern: &str) -> i32 {
    let mut current_floor = 0;
    for p in pattern.chars() {
        match p {
            '(' => current_floor += 1,
            ')' => current_floor -= 1,
            _ => unreachable!("impossible value"),
        }
    }
    current_floor
}

pub fn get_index_for_floor_number(pattern: &str, target: i32) -> usize {
    let mut current_floor = 0;
    for (i, p) in pattern.chars().enumerate() {
        match p {
            '(' => current_floor += 1,
            ')' => current_floor -= 1,
            _ => unreachable!("impossible value"),
        }
        if current_floor == target {
            return i + 1;
        }
    }

    usize::MAX
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input = util::Input::new("day01.txt", crate::YEAR)
            .unwrap()
            .to_string();
        assert_eq!(get_floor_number(&input), 232);
        assert_eq!(get_index_for_floor_number(&input, -1), 1783);
    }
}
