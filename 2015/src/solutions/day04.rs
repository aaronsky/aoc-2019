use md5::{Digest, Md5};

pub fn lowest_number_in_hash(key: &str, start: &str) -> Option<u32> {
    for n in 1.. {
        let input = format!("{}{}", key, n);
        let mut hash = Md5::new();
        hash.update(&input);
        let out = format!("{:02x}", hash.finalize());
        if out.starts_with(start) {
            return Some(n);
        }
    }

    None
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let key = util::Input::new("day04.txt", crate::YEAR)
            .unwrap()
            .to_string();

        assert_eq!(lowest_number_in_hash(&key, "00000"), Some(346386));
    }

    #[test]
    #[cfg(not(debug_assertions))]
    fn test_advent_puzzle_two() {
        let key = util::Input::new("day04.txt", crate::YEAR)
            .unwrap()
            .to_string();

        assert_eq!(lowest_number_in_hash(&key, "000000"), Some(9958218));
    }
}
