use std::collections::HashMap;
use std::fmt;

#[derive(Debug, Hash, Eq, PartialEq, Clone, PartialOrd)]
pub enum Pixel {
    Black = 0,
    White = 1,
    Transparent = 2,
}

impl Default for Pixel {
    fn default() -> Self {
        Pixel::Transparent
    }
}

impl From<char> for Pixel {
    fn from(input: char) -> Self {
        match input {
            '0' => Pixel::Black,
            '1' => Pixel::White,
            '2' => Pixel::Transparent,
            _ => panic!("unsupported char {}", input),
        }
    }
}

impl Into<char> for Pixel {
    fn into(self) -> char {
        match self {
            Pixel::Black => '0',
            Pixel::White => '1',
            Pixel::Transparent => '2',
        }
    }
}

#[derive(Debug, PartialEq)]
pub struct Layer {
    pub pixels: Vec<Pixel>,
    pixel_count_map: HashMap<Pixel, usize>,
    width: usize,
    height: usize,
}

impl Layer {
    pub fn count_pixel(&self, pixel: Pixel) -> usize {
        self.pixel_count_map
            .get(&pixel)
            .cloned()
            .unwrap_or_default()
    }
}

impl Layer {
    fn new(width: usize, height: usize) -> Self {
        Layer {
            pixels: vec![Pixel::default(); width * height],
            pixel_count_map: HashMap::new(),
            width,
            height,
        }
    }

    // fn pretty_format(&self) -> String {
    //     let mut tabbed_layer_string = String::new();
    //     let layer_string = self.to_string();
    //     for row in 0..self.height {
    //         let low_bound = row * self.width;
    //         let high_bound = (row + 1) * self.width;
    //         let row_string = &layer_string[low_bound..high_bound];
    //         tabbed_layer_string.push_str(row_string);
    //         tabbed_layer_string.push_str("\n\t");
    //     }
    //     tabbed_layer_string
    // }
}

impl<'a> From<RawImage<'a>> for Layer {
    fn from(raw_image: RawImage<'a>) -> Self {
        let mut pixels_vec = vec![];
        let mut pixel_count_map = HashMap::new();
        for pixel in raw_image.pixels.chars() {
            let p = Pixel::from(pixel);
            pixels_vec.push(p.clone());
            match pixel_count_map.remove(&p) {
                Some(count) => pixel_count_map.insert(p, count + 1),
                None => pixel_count_map.insert(p, 1),
            };
        }
        Layer {
            pixels: pixels_vec,
            pixel_count_map,
            width: raw_image.width,
            height: raw_image.height,
        }
    }
}

impl From<Layers> for Layer {
    fn from(layers: Layers) -> Self {
        let widths_and_heights = layers.iter().map(|l| (l.width, l.height));
        assert_eq!(
            widths_and_heights.clone().min(),
            widths_and_heights.clone().max()
        );
        let mut combined_layer = Layer::new(layers[0].width, layers[0].height);
        for layer in layers {
            for (i, layer_pixel) in layer.pixels.iter().enumerate() {
                match combined_layer.pixels.get_mut(i) {
                    Some(combined_pixel) if combined_pixel == &Pixel::Transparent => {
                        combined_layer.pixels[i] = layer_pixel.clone();
                    }
                    None => combined_layer.pixels[i] = layer_pixel.clone(),
                    _ => continue,
                }
            }
        }
        combined_layer
    }
}

impl fmt::Display for Layer {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(
            f,
            "{}",
            self.pixels
                .iter()
                .map(|p| Into::<char>::into(p.clone()))
                .collect::<String>()
        )
    }
}

struct RawImage<'a> {
    pixels: &'a str,
    width: usize,
    height: usize,
}

type Layers = Vec<Layer>;

impl<'a> From<RawImage<'a>> for Layers {
    fn from(raw_image: RawImage<'a>) -> Self {
        assert_eq!(
            raw_image.pixels.len() % (raw_image.width * raw_image.height),
            0
        );
        let layer_count = raw_image.pixels.len() / (raw_image.width * raw_image.height);
        let mut layers: Vec<Layer> = Vec::with_capacity(layer_count);
        for l in 0..layer_count {
            let low_bound = raw_image.width * raw_image.height * l;
            let high_bound = raw_image.width * raw_image.height * (l + 1);
            layers.push(Layer::from(RawImage {
                pixels: &raw_image.pixels[low_bound..high_bound],
                width: raw_image.width,
                height: raw_image.height,
            }))
        }
        layers
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::util;

    #[test]
    fn test_advent_puzzle() {
        let layers = util::load_input_file("day08.txt", |input| {
            Layers::from(RawImage {
                pixels: input,
                width: 25,
                height: 6,
            })
        })
        .unwrap();
        let combined = Layer::from(layers);
        assert_eq!(combined.to_string(), "100100110001100111101111010010100101001010000100001111010000100001110011100100101000010110100001000010010100101001010000100001001001100011101000011110");
    }

    #[test]
    fn smoke_simple_program_1() {
        let pixels = "0222112222120000";
        let layers = Layers::from(RawImage {
            pixels,
            width: 2,
            height: 2,
        });
        let combined = Layer::from(layers);
        assert_eq!(combined.to_string(), "0110");
    }
}
