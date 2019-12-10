pub fn number_of_digits(num: f64) -> f64 {
    f64::floor(f64::log10(num) + 1.0)
}

pub fn digit_at_index(index: u32, num: u32) -> u8 {
    let mask = u32::pow(10, index);
    ((num / mask) % 10) as u8
}
