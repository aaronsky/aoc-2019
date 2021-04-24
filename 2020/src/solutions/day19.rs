use itertools::Itertools;
use std::{collections::HashMap, str::FromStr};

#[derive(Debug)]
pub enum Rule {
    Match(String),
    Refs(Vec<usize>),
    Either(Vec<usize>, Vec<usize>),
}

impl Rule {
    fn combinations(&self, all_rules: &HashMap<usize, Rule>) -> Vec<String> {
        match self {
            Rule::Match(s) => vec![dbg!(s).clone()],
            Rule::Refs(ids) => vec![all_rules
                .iter()
                .filter(|(id, _)| ids.contains(id))
                .flat_map(|(_, r)| r.combinations(&all_rules))
                .collect::<String>()],
            Rule::Either(left, right) => vec![
                all_rules
                    .iter()
                    .filter(|(id, _)| left.contains(id))
                    .flat_map(|(_, r)| r.combinations(&all_rules))
                    .collect::<String>(),
                all_rules
                    .iter()
                    .filter(|(id, _)| right.contains(id))
                    .flat_map(|(_, r)| r.combinations(&all_rules))
                    .collect::<String>(),
            ],
        }
    }
}

impl FromStr for Rule {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        if s.contains("|") {
            let comps = s.split("|").collect_vec();
            let left = comps[0]
                .split(' ')
                .map(usize::from_str)
                .filter_map(Result::ok)
                .collect();
            let right = comps[1]
                .split(' ')
                .map(usize::from_str)
                .filter_map(Result::ok)
                .collect();
            Ok(Self::Either(left, right))
        } else {
            let ids = s
                .split(' ')
                .map(usize::from_str)
                .filter_map(Result::ok)
                .collect_vec();
            if ids.is_empty() {
                Ok(Self::Match(s.to_string()))
            } else {
                Ok(Self::Refs(ids))
            }
        }
    }
}

#[derive(Debug)]
pub struct RulesEngine {
    rules: HashMap<usize, Rule>,
    messages: Vec<String>,
}

impl RulesEngine {
    pub fn filter_valid(&self) -> usize {
        assert!(self.rules.contains_key(&0));
        let rule_zero = self.rules.get(&0).unwrap().combinations(&self.rules);
        println!("{:?}", rule_zero);
        self.messages.iter().fold(0, |mut acc, message| {
            if rule_zero.iter().any(|c| message.contains(c)) {
                acc += 1;
            }
            acc
        })
    }
}

impl FromStr for RulesEngine {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let comps = s.split("\n\n").take(2).collect::<Vec<_>>();
        let (rules_raw, messages_raw) = (comps[0], comps[1]);
        let rules = rules_raw
            .lines()
            .filter_map(|line| {
                let comps = line.split(": ").collect::<Vec<_>>();
                let (id_raw, rules_raw) = (comps[0], comps[1]);

                let id = usize::from_str(id_raw).ok()?;
                let rule = Rule::from_str(rules_raw).ok()?;

                Some((id, rule))
            })
            .collect();
        let messages = messages_raw
            .lines()
            .map(ToOwned::to_owned)
            .collect::<Vec<_>>();
        Ok(Self { rules, messages })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input: RulesEngine = util::Input::new("day19.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        // println!("{:?}", input.rules);
        assert_eq!(input.filter_valid(), 0);
    }
}
