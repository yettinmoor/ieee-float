# IEEE-754 32/64-bit float analyzer

This very simple program breaks down float32 and float64 values into sign bit, exponent and mantissa. Written as an exercise to learn more about IEEE-754 floats.


```zig
pub fn main() !void {
    analyzeFloat(f32, 8);
    analyzeFloat(f32, 9.1);
    analyzeFloat(f32, 1.23e-40);
    analyzeFloat(f32, -120.42);
    analyzeFloat(f32, @bitCast(f32, @as(u32, 0x7f80_0000))); // inf

    analyzeFloat(f64, 16);
    analyzeFloat(f64, 12345678900000000000000000.1);
    analyzeFloat(f64, 1e-310);
    analyzeFloat(f64, @bitCast(f64, @as(u64, 0x7ff0_0000_0000_0001))); // NaN
}
```

```
value    | f32: 8.00000 (8.00000e+00)
-----------------------
bits     | 0x41000000
sign     | 0
mantissa | 1.00000000 (0x000000)
exponent | 3

value    | f32: 9.10000 (9.10000e+00)
-----------------------
bits     | 0x4111999a
sign     | 0
mantissa | 1.13750005 (0x11999a)
exponent | 3

value    | f32: 0.00000 (1.23000e-40)
-----------------------
bits     | 0x000156e0
sign     | 0
mantissa | 0.01046371 (0x0156e0)
exponent | -126

value    | f32: -120.42000 (-1.20420e+02)
-----------------------
bits     | 0xc2f0d70a
sign     | 1
mantissa | -1.88156247 (0x70d70a)
exponent | 6

value    | f32: inf (inf)
-----------------------
bits     | 0x7f800000
sign     | 0
mantissa | 1.00000000 (0x000000)
exponent | 255 (special)

value    | f64: 16.00000 (1.60000e+01)
-----------------------
bits     | 0x4030000000000000
sign     | 0
mantissa | 1.00000000 (0x000000)
exponent | 4

value    | f64: 12345678900000000000000000.00000 (1.23457e+25)
-----------------------
bits     | 0x45246c99303c37aa
sign     | 0
mantissa | 1.13825664 (0x46c99303c37aa)
exponent | 83

value    | f64: 0.00000 (1.00000e-310)
-----------------------
bits     | 0x12688b70e62b
sign     | 0
mantissa | 0.00224712 (0x12688b70e62b)
exponent | -1022

value    | f64: nan (nan)
-----------------------
bits     | 0x7ff0000000000001
sign     | 0
mantissa | 1.00000000 (0x000001)
exponent | 2047 (special)
```
