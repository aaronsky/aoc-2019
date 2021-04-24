use lazy_static::lazy_static;
use regex::Regex;
use std::{
    collections::{HashMap, HashSet},
    iter::FromIterator,
    str::FromStr,
};

#[derive(Debug)]
struct Food {
    ingredients: HashSet<String>,
    allergens: HashSet<String>,
}

struct FoodSupply {
    food: Vec<Food>,
    all_allergens: HashMap<String, HashSet<String>>,
}

impl FromStr for FoodSupply {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        lazy_static! {
            static ref LINE_MATCH: Regex =
                Regex::new("((?:\\w+ )+)\\(contains((?: \\w+,?)+)\\)").unwrap();
        }

        let mut foods = vec![];
        let mut allergens: HashMap<String, HashSet<String>> = HashMap::new();
        for line in s.lines() {
            let matches = LINE_MATCH.captures(line.trim()).unwrap();
            let ingredients: HashSet<String> = HashSet::from_iter(
                matches
                    .get(1)
                    .unwrap()
                    .as_str()
                    .trim()
                    .split(' ')
                    .map(ToString::to_string),
            );
            let allergies: HashSet<String> = HashSet::from_iter(
                matches
                    .get(2)
                    .unwrap()
                    .as_str()
                    .trim()
                    .split(' ')
                    .map(ToString::to_string),
            );
            foods.append(&mut ingredients.into_iter().collect());
            for allergy in allergies {
                let i = ingredients.iter().cloned().collect();
                match allergens.get_mut(&allergy) {
                    Some(a) => {
                        *a = a.intersection(&i).cloned().collect();
                    }
                    None => {
                        allergens.insert(allergy, i);
                    }
                };
            }
        }
        todo!()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle_one() {
        let input = util::Input::new("day21.txt", crate::YEAR).unwrap();
    }
}
