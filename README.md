# IEEE-754 32-bit float analyzer

This very simple program breaks down float32 values into sign bit, exponent and mantissa. Written as an exercise to learn more about IEEE-754 floats.


```zig
pub fn main() !void {
    analyzeFloat(8);
    analyzeFloat(9.1);
    analyzeFloat(-120.42);
    analyzeFloat(@bitCast(f32, @as(u32, 0x7f80_0000))); // inf
}
```

```
value    | 8.0000e+00
-----------------------
bits     | 0x41000000
sign     | 0
mantissa | 1.00000e+00 (0x000000)
exp      | 3 (130)

value    | 9.1000e+00
-----------------------
bits     | 0x4111999a
sign     | 0
mantissa | 1.13750e+00 (0x11999a)
exp      | 3 (130)

value    | -1.2042e+02
-----------------------
bits     | 0xc2f0d70a
sign     | 1
mantissa | -1.88156e+00 (0x70d70a)
exp      | 6 (133)

value    | inf
-----------------------
bits     | 0x7f800000
sign     | 0
mantissa | 1.00000e+00 (0x000000)
exp      | 255 (special value)
```
