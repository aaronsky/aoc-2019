use std::collections::HashSet;
use std::str::FromStr;

#[derive(Debug)]
pub struct Passport {
    birth_year: Option<String>,
    issue_year: Option<String>,
    exp_year: Option<String>,
    height: Option<String>,
    hair_color: Option<String>,
    eye_color: Option<String>,
    passport_id: Option<String>,
    country_id: Option<String>,
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
        if let Some(ref birth_year) = self.birth_year {
            let val = u32::from_str(&birth_year).unwrap_or_default();
            if val > 2002 || val < 1920 {
                return false;
            }
        } else {
            return false;
        }

        // iyr (Issue Year) - four digits; at least 2010 and at most 2020.
        if let Some(ref issue_year) = self.issue_year {
            let val = u32::from_str(&issue_year).unwrap_or_default();
            if val > 2020 || val < 2010 {
                return false;
            }
        } else {
            return false;
        }

        // eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
        if let Some(ref exp_year) = self.exp_year {
            let val = u32::from_str(&exp_year).unwrap_or_default();
            if val > 2030 || val < 2020 {
                return false;
            }
        } else {
            return false;
        }

        // hgt (Height) - a number followed by either cm or in:
        //     If cm, the number must be at least 150 and at most 193.
        //     If in, the number must be at least 59 and at most 76.
        if let Some(ref height) = self.height {
            if height.ends_with("cm") {
                let val = u32::from_str(&height.replace("cm", "")).unwrap_or_default();
                if val > 193 || val < 150 {
                    return false;
                }
            } else if height.ends_with("in") {
                let val = u32::from_str(&height.replace("in", "")).unwrap_or_default();
                if val > 76 || val < 59 {
                    return false;
                }
            } else {
                return false;
            }
        } else {
            return false;
        }

        // hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
        if let Some(ref hair_color) = self.hair_color {
            if !hair_color.starts_with("#") || hair_color.len() != 7 {
                return false;
            }
            let val = u32::from_str_radix(&hair_color.replace("#", ""), 16);
            if val.is_err() {
                return false;
            }
        } else {
            return false;
        }

        // ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
        let eye_colors = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
            .iter()
            .map(ToString::to_string)
            .collect::<HashSet<String>>();
        if let Some(ref eye_color) = self.eye_color {
            if !eye_colors.contains(eye_color) {
                return false;
            }
        } else {
            return false;
        }

        // pid (Passport ID) - a nine-digit number, including leading zeroes.
        if let Some(ref passport_id) = self.passport_id {
            if passport_id.len() != 9 {
                return false;
            }
            let val = u32::from_str(&passport_id);
            if val.is_err() {
                return false;
            }
        } else {
            return false;
        }

        true
    }
}

impl FromStr for Passport {
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        let mut birth_year = None;
        let mut issue_year = None;
        let mut exp_year = None;
        let mut height = None;
        let mut hair_color = None;
        let mut eye_color = None;
        let mut passport_id = None;
        let mut country_id = None;

        for field in s.replace("\n", " ").split(' ') {
            if field.is_empty() {
                continue;
            }

            let comps: Vec<&str> = field.split(':').take(2).collect();
            let (key, value) = (comps[0], comps[1]);
            match key {
                "byr" => birth_year = Some(value.to_string()),
                "iyr" => issue_year = Some(value.to_string()),
                "eyr" => exp_year = Some(value.to_string()),
                "hgt" => height = Some(value.to_string()),
                "hcl" => hair_color = Some(value.to_string()),
                "ecl" => eye_color = Some(value.to_string()),
                "pid" => passport_id = Some(value.to_string()),
                "cid" => country_id = Some(value.to_string()),
                _ => unreachable!("impossible value"),
            }
        }

        Ok(Passport {
            birth_year,
            issue_year,
            exp_year,
            height,
            hair_color,
            eye_color,
            passport_id,
            country_id,
        })
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
