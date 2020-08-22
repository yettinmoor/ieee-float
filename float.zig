const std = @import("std");
const warn = std.debug.warn;

pub fn main() !void {
    analyzeFloat(8);
    analyzeFloat(9.1);
    analyzeFloat(-120.42);
    analyzeFloat(@bitCast(f32, @as(u32, 0x7f80_0000))); // inf
}

fn analyzeFloat(f: f32) void {
    const f_bits = @bitCast(u32, f);

    const sign = @intCast(u1, (f_bits & 0x8000_0000) >> 31);
    const mantissa = @as(u32, f_bits & 0x007f_ffff);
    const exp = blk: {
        const bias = 127;
        var exp = @intCast(i9, (f_bits & 0x7f80_0000) >> 23);
        if (exp == 0xff) break :blk exp;

        if (exp == 0) exp = 1;
        break :blk exp - bias;
    };

    const mantissa_f = blk: {
        var mantissa_f: f64 = if (exp == 0) 0 else 1;
        var mantissa_copy = mantissa;
        var pow: u64 = 2;
        while (mantissa_copy != 0) : (mantissa_copy <<= 1) {
            if (mantissa_copy & 0x0040_0000 != 0)
                mantissa_f += 1 / @intToFloat(f32, pow);
            pow *= 2;
        }
        if (sign == 1) mantissa_f *= -1;
        break :blk mantissa_f;
    };

    warn("float bits | 0x{x:0<8}\n", .{f_bits});
    warn("sign       | {}\n", .{sign});
    warn("mantissa   | 0x{x:0<6}\n", .{mantissa});

    warn("exp        | {}", .{exp});
    if (exp == 0xff)
        warn(" (special value)", .{});
    warn("\n", .{});

    warn(" -> {:.2} = {} * 2 ^ {}\n\n", .{
        f,
        mantissa_f,
        exp,
    });
}
