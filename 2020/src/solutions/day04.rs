use crate::shared::Passport;
use std::str::FromStr;

fn validate_in_range<N>(field: &Option<String>, min: N, max: N) -> bool
where
    N: Ord + FromStr,
{
    field
        .to_owned()
        .and_then(|s| N::from_str(&s).ok())
        .map(|y| y <= max && y >= min)
        .unwrap_or_default()
}

fn validate_cm_in_range(field: &str, min: u32, max: u32) -> bool {
    validate_in_range(&Some(field.replace("cm", "")), min, max)
}

fn validate_inch_in_range(field: &str, min: u32, max: u32) -> bool {
    validate_in_range(&Some(field.replace("in", "")), min, max)
}

fn validate_number_of_length(field: &Option<String>, len: u32) -> bool {
    field
        .to_owned()
        .filter(|s| s.len() == len as usize)
        .is_some()
        && validate_in_range(field, 0, 10_u32.pow(len) - 1)
}

impl Passport {
    pub fn required_fields_set(&self) -> bool {
        self.birth_year.is_some()
            && self.issue_year.is_some()
            && self.exp_year.is_some()
            && self.height.is_some()
            && self.hair_color.is_some()
            && self.eye_color.is_some()
            && self.passport_id.is_some()
    }

    pub fn required_fields_valid(&self) -> bool {
        // byr (Birth Year) - four digits; at least 1920 and at most 2002.
        // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        // hgt (Height) - a number followed by either cm or in:
        //     If cm, the number must be at least 150 and at most 193.
        //     If in, the number must be at least 59 and at most 76.
        // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        // pid (Passport ID) - a nine-digit number, including leading zeroes.

        let height = self
            .height
            .to_owned()
            .filter(|s| validate_cm_in_range(&s, 150, 193) || validate_inch_in_range(&s, 59, 76))
            .is_some();

        let hair_color = self
            .hair_color
            .to_owned()
            .filter(|s| s.starts_with('#') && s.len() == 7)
            .map(|s| u32::from_str_radix(&s.replace("#", ""), 16).ok())
            .flatten()
            .is_some();

        let eye_color = self
            .eye_color
            .to_owned()
            .filter(|s| {
                [
                    String::from("amb"),
                    String::from("blu"),
                    String::from("brn"),
                    String::from("gry"),
                    String::from("grn"),
                    String::from("hzl"),
                    String::from("oth"),
                ]
                .contains(s)
            })
            .is_some();

        validate_in_range(&self.birth_year, 1920, 2002)
            && validate_in_range(&self.issue_year, 2010, 2020)
            && validate_in_range(&self.exp_year, 2020, 2030)
            && height
            && hair_color
            && eye_color
            && validate_number_of_length(&self.passport_id, 9)
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let passports: Vec<Passport> = util::load_input_file("day04.txt", crate::YEAR)
            .unwrap()
            .into_vec::<String>("\n\n")
            .iter()
            .map(|s| Passport::from_str(s).unwrap())
            .collect();

        let valid_one: Vec<Passport> = passports
            .into_iter()
            .filter(|p| p.required_fields_set())
            .collect();
        assert_eq!(valid_one.len(), 247);

        let valid_two: Vec<Passport> = valid_one
            .into_iter()
            .filter(|p| p.required_fields_valid())
            .collect();
        assert_eq!(valid_two.len(), 145);
    }
}
