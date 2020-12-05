pub fn len_in_memory(s: &str) -> usize {
    let mut count = 0;

    let mut chars = s.chars();
    while let Some(c) = chars.next() {
        match c {
            '"' => continue,
            '\\' => {
                match chars.next() {
                    Some('\\') => {}
                    Some('"') => {}
                    Some('x') => {
                        assert!(chars
                            .next()
                            .map(|nc| nc.is_ascii_hexdigit())
                            .unwrap_or_default());
                        assert!(chars
                            .next()
                            .map(|nc| nc.is_ascii_hexdigit())
                            .unwrap_or_default());
                    }
                    _ => unreachable!("impossible input"),
                };
            }
            _ => {}
        }
        count += 1;
    }

    count
}

pub fn encode_str(s: &str) -> String {
    let mut encoded = s.chars().fold(String::from('"'), |mut acc, c| {
        match c {
            '"' => acc.push_str(r#"\""#),
            '\\' => acc.push_str(r#"\\"#),
            c => acc.push(c),
        };
        acc
    });
    encoded.push('"');

    encoded
}

#[cfg(test)]
mod tests {
    use super::*;
    use util;

    #[test]
    fn test_advent_puzzle() {
        let strings: Vec<String> = util::load_input_file("day08.txt", crate::YEAR)
            .unwrap()
            .into_vec::<String>("\n")
            .iter()
            .map(|s| s.trim().to_string())
            .collect();

        let one: usize = strings.iter().map(|s| s.len() - len_in_memory(s)).sum();
        assert_eq!(one, 1333);

        let two: usize = strings.iter().map(|s| &encode_str(s).len() - s.len()).sum();
        assert_eq!(two, 2046);
    }
}
