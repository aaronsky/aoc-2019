use std::collections::HashMap;

pub fn product_of_distributions_in_set(adapters: &[u32]) -> usize {
    let differences = adapters
        .iter()
        .rev()
        .zip(adapters.iter().rev().skip(1))
        .map(|(l, r)| l - r)
        .collect::<Vec<_>>();

    (differences.iter().filter(|d| **d == 1).count() + 1)
        * (differences.iter().filter(|d| **d == 3).count() + 1)
}

pub fn count_distinct_combinations(adapters: &[u32]) -> usize {
    let mut memo = HashMap::<i32, usize>::new();
    memo.insert(0, 1);

    for target in adapters.iter() {
        let sum = (1..=3).fold(0, |mut acc, i| {
            acc += memo.get(&((*target as i32) - i)).unwrap_or(&0);
            acc
        });
        memo.insert(*target as i32, sum);
    }

    *memo.get(&(*adapters.last().unwrap() as i32)).unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let mut adapters = util::Input::new("day10.txt", crate::YEAR)
            .unwrap()
            .into_vec("\n");

        adapters.sort();

        let product = product_of_distributions_in_set(&adapters);
        assert_eq!(product, 1690);

        let combinations = count_distinct_combinations(&adapters);
        assert_eq!(combinations, 5289227976704);
    }
}
