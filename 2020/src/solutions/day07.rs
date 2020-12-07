use std::collections::{HashMap, HashSet};
use std::num::ParseIntError;
use std::str::FromStr;

#[derive(Debug, Hash, PartialEq, Eq)]
pub struct Rule {
    color: String,
    count: u32,
}

impl FromStr for Rule {
    type Err = ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let comps = s.splitn(2, ' ').map(str::trim).collect::<Vec<_>>();
        let (count_raw, color) = (comps[0], comps[1]);
        let count = u32::from_str(count_raw)?;

        Ok(Rule {
            color: color.to_string(),
            count,
        })
    }
}

#[derive(Debug)]
pub struct Rules {
    rules: HashMap<String, HashSet<Rule>>,
}

impl Rules {
    pub fn colors_count(&self, color: &str) -> usize {
        fn including(
            bags: &HashMap<String, HashSet<Rule>>,
            color: &str,
            visited: &mut HashSet<String>,
            contains_target: &mut HashMap<String, bool>,
        ) {
            let mut has_color = false;

            visited.insert(color.to_owned());

            if let Some(rules) = bags.get(color) {
                for rule in rules {
                    if !visited.contains(&rule.color) {
                        including(bags, &rule.color, visited, contains_target);
                    }

                    has_color = has_color
                        || contains_target
                            .get(&rule.color)
                            .map(ToOwned::to_owned)
                            .unwrap_or_default();
                }
            }

            contains_target.insert(color.to_owned(), has_color);
        }

        let mut visited = HashSet::with_capacity(self.rules.len());
        let mut contains_target = HashMap::with_capacity(self.rules.len());

        visited.insert(color.to_owned());
        contains_target.insert(color.to_owned(), true);

        for color in self.rules.keys() {
            if !visited.contains(color) {
                including(&self.rules, color, &mut visited, &mut contains_target);
            }
        }

        contains_target.values().filter(|v| **v).count() - 1
    }

    pub fn color_cost(&self, color: &str) -> u32 {
        fn cost(
            bags: &HashMap<String, HashSet<Rule>>,
            color: &str,
            visited: &mut HashSet<String>,
            sizes: &mut HashMap<String, u32>,
        ) {
            let mut count = 1;

            if let Some(rules) = bags.get(color) {
                for rule in rules {
                    if !visited.contains(&rule.color) {
                        cost(bags, &rule.color, visited, sizes);
                    }

                    count += rule.count * sizes.get(&rule.color).unwrap_or(&0);
                }
            }

            sizes.insert(color.to_owned(), count);
        };

        let mut visited = HashSet::with_capacity(self.rules.len());
        let mut sizes = HashMap::with_capacity(self.rules.len());

        cost(&self.rules, &color, &mut visited, &mut sizes);

        sizes.get(&*color).unwrap_or(&1) - 1
    }
}

impl FromStr for Rules {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut rules = HashMap::<String, HashSet<Rule>>::with_capacity(s.lines().count());
        s.lines().fold(&mut rules, |acc, line| {
            let line_replacing_extra_content =
                line.replace(".", "").replace("bags", "").replace("bag", "");
            let comps = line_replacing_extra_content
                .split("contain")
                .map(str::trim)
                .take(2)
                .collect::<Vec<_>>();
            let (key, val_raw) = (comps[0], comps[1]);
            let val = val_raw
                .split(',')
                .map(str::trim)
                .map(Rule::from_str)
                .filter_map(Result::ok)
                .collect();

            acc.insert(key.to_string(), val);

            acc
        });
        Ok(Rules { rules })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let rules: Rules = util::Input::new("day07.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        let combinations_for = rules.colors_count("shiny gold");
        assert_eq!(combinations_for, 252);

        let cost_for = rules.color_cost("shiny gold");
        assert_eq!(cost_for, 35487);
    }
}
