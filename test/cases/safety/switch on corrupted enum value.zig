const std = @import("std");

pub fn panic(message: []const u8, stack_trace: ?*std.builtin.StackTrace, _: ?usize) noreturn {
    _ = stack_trace;
    if (std.mem.eql(u8, message, "switch on corrupt value")) {
        std.process.exit(0);
    }
    std.process.exit(1);
}

const E = enum(u32) {
    X = 1,
    Y = 2,
};

pub fn main() !void {
    var e: E = undefined;
    @memset(@ptrCast([*]u8, &e)[0..@sizeOf(E)], 0x55);
    switch (e) {
        .X, .Y => @breakpoint(),
    }
    return error.TestFailed;
}

// run
// backend=llvm
// target=native
