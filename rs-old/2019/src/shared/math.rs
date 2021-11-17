use util::Point2;

#[derive(Debug, Clone, Copy)]
pub enum Direction {
    Up,
    Down,
    Left,
    Right,
}

pub trait PointDirectionMover {
    fn move_in_direction(&mut self, direction: Direction);
}

impl PointDirectionMover for Point2 {
    fn move_in_direction(&mut self, direction: Direction) {
        self.x += match direction {
            Direction::Right => 1,
            Direction::Left => -1,
            _ => 0,
        };
        self.y += match direction {
            Direction::Up => 1,
            Direction::Down => -1,
            _ => 0,
        }
    }
}
