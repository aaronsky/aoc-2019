use itertools::Itertools;

fn str_to_usize(string: &str) -> usize {
    string.parse::<usize>().unwrap()
}

pub trait Rule {
    fn from(s: &str) -> Self;
    fn is_satisfied(&self, phrase: &str) -> bool;
}

struct CountRule {
    pub min: usize,
    pub max: usize,
    pub c: String,
}

impl Rule for CountRule {
    fn from(s: &str) -> Self {
        let comps = s.split(' ').take(2).collect_vec();
        let bounds = comps[0].split('-').take(2).map(str_to_usize).collect_vec();

        CountRule {
            min: bounds[0],
            max: bounds[1],
            c: comps[1].to_string(),
        }
    }

    fn is_satisfied(&self, phrase: &str) -> bool {
        let count = phrase.matches(&self.c).count();
        count >= self.min && count <= self.max
    }
}

struct PositionRule {
    pub first: usize,
    pub last: usize,
    pub c: String,
}

impl Rule for PositionRule {
    fn from(s: &str) -> Self {
        let comps = s.split(' ').take(2).collect_vec();
        let bounds = comps[0].split('-').take(2).map(str_to_usize).collect_vec();

        PositionRule {
            first: bounds[0],
            last: bounds[1],
            c: comps[1].to_string(),
        }
    }

    fn is_satisfied(&self, phrase: &str) -> bool {
        let first_valid = phrase
            .chars()
            .nth(self.first)
            .map(|c| c.to_string())
            .unwrap()
            .eq(&self.c);
        let last_valid = phrase
            .chars()
            .nth(self.last)
            .map(|c| c.to_string())
            .unwrap()
            .eq(&self.c);
        first_valid ^ last_valid
    }
}

pub struct Password<R: Rule> {
    pub rules: Vec<R>,
    pub phrase: String,
}

impl<R> Password<R>
where
    R: Rule,
{
    pub fn from(s: &str) -> Self {
        let comps = s.split(':').take(2).collect_vec();
        let rules = comps[0].split(',').map(R::from).collect();
        let phrase = comps[1].to_string();
        Password { rules, phrase }
    }

    pub fn is_valid(&self) -> bool {
        self.rules.iter().all(|r| r.is_satisfied(&self.phrase))
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;
    use util::ListInput;

    #[test]
    fn test_advent_puzzle_one() {
        let ListInput(input): ListInput<String> = util::load_input_file("day02.txt").unwrap();
        let passwords = input
            .into_iter()
            .map(|item| Password::<CountRule>::from(&item))
            .collect_vec();
        assert_eq!(passwords.iter().filter(|p| p.is_valid()).count(), 550);
    }

    #[test]
    fn test_advent_puzzle_two() {
        let ListInput(input): ListInput<String> = util::load_input_file("day02.txt").unwrap();
        let passwords = input
            .into_iter()
            .map(|item| Password::<PositionRule>::from(&item))
            .collect_vec();
        assert_eq!(passwords.iter().filter(|p| p.is_valid()).count(), 634);
    }
}
