use std::str::FromStr;

#[derive(Debug)]
pub struct Passport {
    birth_year: Option<u32>,
    issue_year: Option<u32>,
    exp_year: Option<u32>,
    height: Option<String>,
    hair_color: Option<u32>,
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
        false
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
                "byr" => birth_year = u32::from_str(value).ok(),
                "iyr" => issue_year = u32::from_str(value).ok(),
                "eyr" => exp_year = u32::from_str(value).ok(),
                "hgt" => height = Some(value.to_string()),
                "hcl" => hair_color = u32::from_str_radix(&value.replace("#", ""), 16).ok(),
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
            .map(|s| Passport::from_str(s))
            .filter_map(Result::ok)
            .collect();

        let valid_one: Vec<Passport> = passports
            .into_iter()
            .filter(|p| p.required_fields_set())
            .collect();
        assert_eq!(valid_one.len(), 2);

        let valid_two: Vec<Passport> = valid_one
            .into_iter()
            .filter(|p| p.required_fields_valid())
            .collect();
        assert_eq!(valid_two.len(), 2);
    }
}
