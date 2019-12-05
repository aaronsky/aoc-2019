#[allow(dead_code)]
fn fuel_required_for_mass(mass: &i32) -> i32 {
    mass / 3 - 2
}

#[allow(dead_code)]
fn fuel_required_to_launch(modules: &[u32]) -> u32 {
    let mut fuel_required = 0;
    for module in modules {
        let mass = *module as i32;
        let minimum_fuel_required = fuel_required_for_mass(&mass);
        if minimum_fuel_required <= 0 {
            continue;
        }
        let mut remaining_mass = minimum_fuel_required;
        let mut additional_fuel_required = 0;
        while remaining_mass > 0 {
            remaining_mass = fuel_required_for_mass(&remaining_mass);
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

    #[test]
    fn test_advent_puzzle() {
        let modules = vec![
            128167, 65779, 88190, 144176, 109054, 70471, 113510, 81741, 65270, 111217, 51707,
            81122, 142720, 65164, 85045, 85776, 51332, 110021, 99706, 50512, 95429, 149220, 102777,
            93907, 61769, 66946, 121583, 132351, 53809, 73261, 122964, 120792, 73998, 79590,
            140881, 53130, 82498, 72725, 127422, 143777, 55787, 95454, 88293, 107988, 145145,
            59562, 142929, 132977, 88825, 104657, 70644, 124614, 66443, 117825, 97016, 79578,
            136114, 64975, 113838, 63294, 58466, 76827, 56288, 126977, 63815, 129398, 123017,
            118773, 144464, 60620, 79084, 94685, 70854, 148054, 134179, 113832, 113742, 115771,
            115543, 73241, 62914, 146134, 128066, 52002, 132377, 100765, 105048, 59936, 131324,
            137384, 139352, 127350, 116249, 79847, 53530, 99738, 61969, 118730, 121980, 72977,
        ];
        let required_fuel = fuel_required_to_launch(&modules);
        assert_eq!(required_fuel, 4892166);
    }
}
