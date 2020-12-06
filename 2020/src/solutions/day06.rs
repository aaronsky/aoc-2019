use std::collections::{HashMap, HashSet};

pub struct Group;

impl Group {
    pub fn uniques(s: &str) -> usize {
        let mut set = HashSet::with_capacity(26);

        for answer in s.lines().flat_map(str::chars) {
            set.insert(answer);
        }

        set.len()
    }

    pub fn universals(s: &str) -> usize {
        let mut map: HashMap<char, usize> = HashMap::with_capacity(26);
        let mut num_respondents = 0;

        for respondent in s.lines() {
            num_respondents += 1;
            for answer in respondent.chars() {
                match map.remove(&answer) {
                    Some(count) => map.insert(answer, count + 1),
                    None => map.insert(answer, 1),
                };
            }
        }

        map.into_iter()
            .filter(|(_, v)| v == &num_respondents)
            .count()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let groups = util::Input::new("day06.txt", crate::YEAR)
            .unwrap()
            .into_vec::<String>("\n\n");

        let unique_answers: usize = groups.iter().map(|s| Group::uniques(s)).sum();
        assert_eq!(unique_answers, 7120);

        let universal_answers: usize = groups.iter().map(|s| Group::universals(s)).sum();
        assert_eq!(universal_answers, 3570);
    }
}
