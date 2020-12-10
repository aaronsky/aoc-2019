use std::collections::HashMap;
use std::str::FromStr;

#[derive(Debug, Clone, Default, PartialEq, Eq, Hash)]
struct Material {
    name: String,
    count: usize,
}

impl FromStr for Material {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        // 15 ZRSFC, 2 PQVBV, 2 SRGL => 3 SPNRW
        let mut components = s.split(' ').take(2);
        let count = components
            .next()
            .map(str::trim)
            .map(FromStr::from_str)
            .map(|r| r.or(Err(())))
            .ok_or(())
            .and_then(|r| r)?;
        let name = components
            .next()
            .map(str::trim)
            .map(FromStr::from_str)
            .map(|r| r.or(Err(())))
            .ok_or(())
            .and_then(|r| r)?;
        Ok(Material { name, count })
    }
}

#[derive(Debug, Clone, Default)]
pub struct Reaction {
    inputs: Vec<Material>,
    output: Material,
}

impl Reaction {
    pub fn requires_ore(&self) -> bool {
        self.inputs.iter().any(|m| m.name == "ORE")
    }

    pub fn produces_fuel(&self) -> bool {
        self.output.name == "FUEL"
    }
}

impl FromStr for Reaction {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut input_output = s.split("=>").take(2);
        let inputs = input_output
            .next()
            .map(|i| {
                i.split(',')
                    .map(Material::from_str)
                    .filter_map(Result::ok)
                    .collect()
            })
            .ok_or(())?;
        let output = input_output
            .next()
            .map(str::trim)
            .map(Material::from_str)
            .ok_or(())
            .and_then(|r| r)?;
        Ok(Reaction { inputs, output })
    }
}

#[derive(Debug)]
pub struct Reactions {
    reactions: HashMap<String, Reaction>,
}

impl Reactions {
    pub fn required_ore_for_fuel(&self, _count: usize) -> usize {
        let get_inputs_clone_for_material_name = |mat: &str| {
            self.reactions
                .get(mat)
                .unwrap_or(&Default::default())
                .inputs
                .clone()
        };

        let mut inputs_to_determine_cost: Vec<Material> =
            get_inputs_clone_for_material_name("FUEL");
        while let Some(input) = inputs_to_determine_cost.pop() {
            if input.name == "ORE" {
                continue;
            }
            inputs_to_determine_cost.extend(get_inputs_clone_for_material_name(&input.name));
        }
        // find index of fuel
        // work backwards until you reach ore
        // apply counts all the way up to ore
        // return ore count
        inputs_to_determine_cost.len()
    }
}

impl FromStr for Reactions {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let reactions = s
            .split('\n')
            .map(FromStr::from_str)
            .filter_map(Result::ok)
            .map(|r: Reaction| (r.output.name.clone(), r))
            .collect();
        Ok(Reactions { reactions })
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    #[ignore]
    fn test_advent_puzzle_1() {
        let _reactions: Reactions = util::Input::new("day14.txt", crate::YEAR)
            .unwrap()
            .try_into()
            .unwrap();
        // println!("{}", reactions.required_ore_for_fuel(1));
    }

    #[test]
    #[ignore]
    fn test_advent_puzzle_2() {}

    #[test]
    #[ignore]
    fn smoke_simple_program_1() {}

    #[test]
    #[ignore]
    fn smoke_simple_program_2() {}

    #[test]
    #[ignore]
    fn smoke_simple_program_3() {}
}
