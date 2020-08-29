const std = @import("std");
const warn = std.debug.warn;
const IntType = std.meta.IntType;

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

fn FloatBits(comptime Float: type) type {
    return switch (Float) {
        f32 => packed struct {
            mantissa: u23,
            exponent: u8,
            sign_bit: u1,

            const exp_bits = 8;
            const mantissa_bits = 23;
        },
        f64 => packed struct {
            mantissa: u52,
            exponent: u11,
            sign_bit: u1,

            const exp_bits = 11;
            const mantissa_bits = 53;
        },
        f128 => @panic("Unimplemented"),
        else => @panic("Must be float type"),
    };
}

fn analyzeFloat(comptime Float: type, f: Float) void {
    const Bits = FloatBits(Float);
    const f_bits = @bitCast(Bits, f);

    const is_signed = f_bits.sign_bit == 1;

    // Special value: exponent bits all 1
    const is_special_value = f_bits.exponent == (1 << Bits.exp_bits) - 1;

    const SignedExp = IntType(true, Bits.exp_bits + 1);
    const exponent: SignedExp = if (is_special_value)
        f_bits.exponent
    else blk: {
        const bias = (1 << (Bits.exp_bits - 1)) - 1;
        var exp = @intCast(SignedExp, f_bits.exponent);
        if (exp == 0) exp = 1;
        break :blk exp - bias;
    };

    const mantissa = blk: {
        var mantissa: Float = if (f_bits.exponent == 0) 0 else 1;
        mantissa += @intToFloat(Float, f_bits.mantissa) / (1 << Bits.mantissa_bits);
        break :blk if (is_signed) -mantissa else mantissa;
    };

    const fmt =
        \\value    | {}: {d:.5} ({1:.5})
        \\-----------------------
        \\bits     | 0x{x:0<8}
        \\sign     | {}
        \\mantissa | {d:.8} (0x{x:0<6})
        \\exponent | {} {}
    ++ "\n\n";

    const special_desc = @as([]const u8, if (is_special_value) "(special)" else "");
    const stdout = std.io.getStdOut();
    stdout.outStream().print(fmt, .{
        @typeName(Float),
        f,
        @bitCast(IntType(false, @bitSizeOf(Float)), f),
        f_bits.sign_bit,
        mantissa,
        f_bits.mantissa,
        exponent,
        special_desc,
    }) catch unreachable;
}
