use std::fs::File;
use std::io;
use std::io::Read;
use std::path::Path;
use std::str::FromStr;

fn inputs_directory<'a>() -> &'a Path {
    Path::new("src/inputs/")
}

// load file
pub fn load_input_file<S, F>(name: &str, parse: F) -> Result<S, io::Error>
where
    F: Fn(&str) -> S,
{
    let input_file = inputs_directory().join(name);
    let mut contents = String::new();
    File::open(input_file)
        .and_then(|mut file| file.read_to_string(&mut contents))
        .map(|_| parse(&contents))
}

pub fn comma_separate<F, S: FromStr>(input: &str, transform: F) -> Vec<S>
where
    F: Fn(&str) -> S,
{
    input.split(',').map(transform).collect()
}

pub fn input_as_vec<S: FromStr>(input: &str) -> Vec<S> {
    comma_separate(input, |string| string.parse().ok().unwrap())
}
