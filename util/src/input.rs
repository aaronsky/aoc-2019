use std::fs::File;
use std::io::Read;
use std::path::Path;
use std::str::FromStr;

// load file
pub fn load_input_file(name: &str, _year: &'static str) -> Result<Input, ()> {
    let input_file = Path::new("src/inputs/").join(name);
    let mut contents = String::new();

    File::open(input_file)
        .and_then(|mut file| file.read_to_string(&mut contents))
        .map_err(|_| ())?;

    Ok(Input(contents))
}

#[derive(Debug, Default, Clone)]
pub struct Input(String);

impl Input {
    pub fn into_raw(self) -> String {
        self.0
    }

    pub fn into<S: FromStr>(self) -> Option<S> {
        S::from_str(&self.0).ok()
    }

    pub fn into_vec<S: FromStr>(self, sep: &str) -> Vec<S> {
        self.0
            .split(sep)
            .filter(|s| !s.is_empty()) // skip empty lines
            .map(S::from_str)
            .filter_map(Result::ok)
            .collect()
    }
}

impl ToString for Input {
    fn to_string(&self) -> String {
        self.clone().into_raw()
    }
}
