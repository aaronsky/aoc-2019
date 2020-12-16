use itertools::Itertools;
use std::{
    collections::{HashMap, HashSet},
    num::ParseIntError,
    ops::RangeInclusive,
    str::FromStr,
};

#[derive(Debug, Clone)]
struct Ticket {
    values: Vec<u64>,
}

impl FromStr for Ticket {
    type Err = ParseIntError;

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let values = s
            .split(',')
            .map(u64::from_str)
            .filter_map(Result::ok)
            .collect();
        Ok(Self { values })
    }
}

#[derive(Debug)]
pub struct Tickets {
    rules: HashMap<String, Vec<RangeInclusive<u64>>>,
    yours: Ticket,
    nearby: Vec<Ticket>,
}

impl Tickets {
    pub fn get_error_rate(&self) -> u64 {
        let mut rate = 0;

        for nearby in &self.nearby {
            for value in &nearby.values {
                let valid_for_one = self
                    .rules
                    .iter()
                    .flat_map(|(_, r)| r)
                    .any(|r| r.contains(&value));

                if !valid_for_one {
                    rate += value;
                }
            }
        }

        rate
    }

    pub fn identify_fields(&self) -> HashMap<String, u64> {
        assert_eq!(self.rules.len(), self.yours.values.len());

        let valid_nearby = self
            .nearby
            .iter()
            .filter(|t| {
                t.values.iter().all(|v| {
                    self.rules
                        .iter()
                        .flat_map(|(_, r)| r)
                        .any(|r| r.contains(&v))
                })
            })
            .collect::<Vec<_>>();

        let mut identified = Vec::with_capacity(self.yours.values.len());
        let all_fields = self
            .rules
            .iter()
            .map(|(n, _)| n.to_owned())
            .collect::<HashSet<_>>();

        for _ in 0..self.rules.len() {
            identified.push(all_fields.clone());
        }

        for ticket in valid_nearby {
            for (i, value) in ticket.values.iter().enumerate() {
                let mut matches = HashSet::new();
                for (name, rules) in &self.rules {
                    for rule in rules {
                        if rule.contains(value) {
                            matches.insert(name.to_owned());
                        }
                    }
                }
                match identified.get_mut(i) {
                    Some(m) => {
                        *m = m
                            .intersection(&matches)
                            .map(ToOwned::to_owned)
                            .collect::<HashSet<_>>()
                    }
                    None => {
                        identified.insert(i, matches);
                    }
                };
            }
        }

        let mut remove_from_others = HashSet::new();

        while remove_from_others.len() < identified.len() {
            for names in identified.iter_mut() {
                if names.len() == 1 {
                    if let Some(value) = names.iter().nth(0).map(ToOwned::to_owned) {
                        remove_from_others.insert(value.clone());
                        let mut new_names = HashSet::new();
                        new_names.insert(value);
                        *names = new_names;
                    }
                } else if names.len() > 1 {
                    *names = names
                        .difference(&remove_from_others)
                        .map(ToOwned::to_owned)
                        .collect();
                }
            }
        }

        identified
            .into_iter()
            .enumerate()
            .map(|(i, names)| (names.into_iter().next().unwrap(), self.yours.values[i]))
            .collect()
    }
}

impl FromStr for Tickets {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let comps = s.split("\n\n").take(3).collect::<Vec<_>>();
        let (rules_raw, yours_raw, nearby_raw) = (comps[0], comps[1], comps[2]);

        let rules = rules_raw
            .lines()
            .filter_map(|s| {
                let (name, rules_raw) = s.split(": ").collect_tuple()?;

                let rules = rules_raw
                    .split(" or ")
                    .map(|s| {
                        let (low, high) = s
                            .split('-')
                            .take(2)
                            .map(u64::from_str)
                            .filter_map(Result::ok)
                            .collect_tuple()
                            .unwrap();
                        low..=high
                    })
                    .collect::<Vec<_>>();

                Some((name.to_owned(), rules))
            })
            .collect();

        let yours = yours_raw
            .lines()
            .skip(1)
            .take(1)
            .map(Ticket::from_str)
            .filter_map(Result::ok)
            .nth(0)
            .unwrap();

        let nearby = nearby_raw
            .lines()
            .skip(1)
            .map(Ticket::from_str)
            .filter_map(Result::ok)
            .collect::<Vec<_>>();

        Ok(Self {
            rules,
            yours,
            nearby,
        })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let input: Tickets = util::Input::new("day16.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();

        assert_eq!(input.get_error_rate(), 26026);

        assert_eq!(
            input
                .identify_fields()
                .iter()
                .filter(|(name, _)| name.starts_with("departure"))
                .map(|(_, value)| *value)
                .product::<u64>(),
            1305243193339
        );
    }
}
