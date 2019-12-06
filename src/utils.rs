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

pub fn parse_comma_separated_content<F, S: FromStr>(input: &str, transform: F) -> Vec<S>
where
    F: Fn(&str) -> S,
{
    input.split(",").map(transform).collect()
}

pub fn parse_comma_separated_content_into_vec_of_fromstr_data<S: FromStr>(input: &str) -> Vec<S> {
    parse_comma_separated_content(input, |string| string.parse().ok().unwrap())
}
