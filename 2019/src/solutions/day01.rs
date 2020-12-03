pub fn fuel_required_for_mass(mass: i32) -> i32 {
    mass / 3 - 2
}

pub fn fuel_required_to_launch(modules: &[u32]) -> u32 {
    let mut fuel_required = 0;
    for module in modules {
        let mass = *module as i32;
        let minimum_fuel_required = fuel_required_for_mass(mass);
        if minimum_fuel_required <= 0 {
            continue;
        }
        let mut remaining_mass = minimum_fuel_required;
        let mut additional_fuel_required = 0;
        while remaining_mass > 0 {
            remaining_mass = fuel_required_for_mass(remaining_mass);
            if remaining_mass <= 0 {
                break;
            }
            additional_fuel_required += remaining_mass as u32;
        }
        fuel_required += (minimum_fuel_required as u32) + additional_fuel_required;
    }
    fuel_required
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let modules = util::load_input_file("day01.txt", crate::YEAR)
            .unwrap()
            .into_vec("\n");
        let required_fuel = fuel_required_to_launch(&modules);
        assert_eq!(required_fuel, 4892166);
    }
}
