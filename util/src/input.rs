use std::io::Read;
use std::path::Path;
use std::str::FromStr;
use std::{fs::File, io};

#[derive(Debug, Default)]
pub struct Input(String);

impl Input {
    pub fn new(name: &str, _year: &'static str) -> Result<Self, io::Error> {
        let input_file = Path::new("src/inputs/").join(name);
        let mut contents = String::new();

        File::open(input_file).and_then(|mut file| file.read_to_string(&mut contents))?;

        Ok(Input(contents))
    }

    pub fn to_string(self) -> String {
        self.0
    }

    pub fn try_into<T>(self) -> Result<T, T::Err>
    where
        T: FromStr,
    {
        T::from_str(&self.0)
    }

    pub fn to_vec<T>(self, sep: &str) -> Vec<T>
    where
        T: FromStr,
    {
        self.0
            .split(sep)
            .filter(|s| !s.is_empty()) // skip empty lines
            .map(T::from_str)
            .filter_map(Result::ok)
            .collect()
    }
}
