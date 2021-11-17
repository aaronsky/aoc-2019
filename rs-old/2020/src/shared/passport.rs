use std::str::FromStr;

#[derive(Debug)]
pub struct Passport {
    pub birth_year: Option<String>,
    pub issue_year: Option<String>,
    pub exp_year: Option<String>,
    pub height: Option<String>,
    pub hair_color: Option<String>,
    pub eye_color: Option<String>,
    pub passport_id: Option<String>,
    pub country_id: Option<String>,
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
