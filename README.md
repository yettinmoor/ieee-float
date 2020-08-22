# IEEE-754 32-bit float analyzer

This very simple program breaks down float32 values into sign bit, exponent and mantissa. Written as an exercise to learn more about IEEE-754 floats.


```{zig}
pub fn main() !void {
    analyzeFloat(8);
    analyzeFloat(9.1);
    analyzeFloat(-120.42);
    analyzeFloat(@bitCast(f32, @as(u32, 0x7f80_0000))); // inf
}
```

```
float bits | 0x41000000
sign       | 0
mantissa   | 0x000000
exp        | 3
 -> 8.00e+00 = 1.0e+00 * 2 ^ 3

float bits | 0x4111999a
sign       | 0
mantissa   | 0x11999a
exp        | 3
 -> 9.10e+00 = 1.1375000476837158e+00 * 2 ^ 3

float bits | 0xc2f0d70a
sign       | 1
mantissa   | 0x70d70a
exp        | 6
 -> -1.20e+02 = -1.8815624713897705e+00 * 2 ^ 6

float bits | 0x7f800000
sign       | 0
mantissa   | 0x000000
exp        | 255 (special value)
 -> inf = 1.0e+00 * 2 ^ 255
```
