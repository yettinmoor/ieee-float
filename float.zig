const std = @import("std");
const warn = std.debug.warn;

pub fn main() !void {
    analyzeFloat(8);
    analyzeFloat(9.1);
    analyzeFloat(-120.42);
    analyzeFloat(@bitCast(f32, @as(u32, 0x7f80_0000))); // inf
}

const FloatBits = packed struct {
    mantissa: u23,
    exponent: u8,
    sign_bit: u1,
};

fn analyzeFloat(f: f32) void {
    const f_bits = @bitCast(FloatBits, f);

    const exp = blk: {
        const bias = 127;
        var exp = @intCast(i9, f_bits.exponent);
        if (exp == 0xff) break :blk exp;
        if (exp == 0) exp = 1;
        break :blk @intCast(i8, exp - bias);
    };

    const mantissa_f = blk: {
        var mantissa_f: f64 = if (exp == 0) 0 else 1;
        var mantissa = f_bits.mantissa;
        var pow: u64 = 2;
        while (mantissa != 0) : (mantissa <<= 1) {
            if (mantissa & 0x0040_0000 != 0)
                mantissa_f += 1 / @intToFloat(f32, pow);
            pow *= 2;
        }
        if (f_bits.sign_bit == 1) mantissa_f *= -1;
        break :blk mantissa_f;
    };

    warn("value    | {:.4}\n", .{f});
    warn("-----------------------\n", .{});
    warn("bits     | 0x{x:0<8}\n", .{@bitCast(u32, f)});
    warn("sign     | {}\n", .{f_bits.sign_bit});
    warn("mantissa | {:.5} (0x{x:0<6})\n", .{ mantissa_f, f_bits.mantissa });

    switch (exp) {
        0x00 => warn("exp      | 0 (denormalized)", .{}),
        0xff => warn("exp      | 255 (special value)", .{}),
        else => warn("exp      | {} ({})", .{ exp, f_bits.exponent }),
    }
    warn("\n\n", .{});
}
