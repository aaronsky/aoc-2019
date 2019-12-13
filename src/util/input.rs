use std::fs::File;
use std::io::Read;
use std::path::Path;
use std::str::FromStr;

fn inputs_directory<'a>() -> &'a Path {
    Path::new("src/inputs/")
}

// load file
pub fn load_input_file<S>(name: &str) -> Result<S, ()>
where
    S: FromStr,
{
    let input_file = inputs_directory().join(name);
    let mut contents = String::new();
    File::open(input_file)
        .and_then(|mut file| file.read_to_string(&mut contents))
        .map_err(|_| ())
        .and_then(|_| S::from_str(&contents).map_err(|_| ()))
}

pub struct ListInput<S: FromStr>(pub Vec<S>);

impl<S> FromStr for ListInput<S>
where
    S: FromStr,
{
    type Err = ();

    fn from_str(s: &str) -> Result<Self, Self::Err> {
        Ok(ListInput(
            s.split(',')
                .map(S::from_str)
                .filter_map(Result::ok)
                .collect(),
        ))
    }
}
