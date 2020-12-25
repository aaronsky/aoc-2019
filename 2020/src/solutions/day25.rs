pub fn encryption_key_matching(key1: u64, key2: u64) -> u64 {
    let mut loop1 = None;
    let mut loop2 = None;

    let mut acc = 1;
    for i in 1.. {
        acc = (acc * 7) % 20201227;

        if acc == key1 {
            loop1 = Some(i);
        }
        if acc == key2 {
            loop2 = Some(i);
        }

        if loop1.is_some() && loop2.is_some() {
            break;
        }
    }

    return transform(key1, loop2.unwrap());
}

pub fn transform(subject: u64, loop_count: u64) -> u64 {
    (0..loop_count).fold(1, |acc, _| (acc * subject) % 20201227)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_advent_puzzle_one() {
        let card = 10705932;
        let door = 12301431;

        let key = encryption_key_matching(card, door);

        assert_eq!(key, 11328376);
    }
}
