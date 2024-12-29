const std = @import("std");
const Godot = @import("godot");

const Self = @This();
pub usingnamespace Godot.Node3D;
base: Godot.Node,

pub fn _enter_tree(self: *Self) void {
    _ = self;
    std.debug.print("_enter_tree\n", .{});
}

pub fn _process(self: *Self, delta: f64) void {
    _ = self;
    _ = delta;
}

pub fn _notification(self: *Self, what: i32) void {
    if (what == Godot.Node.NOTIFICATION_WM_CLOSE_REQUEST) {
        self.getTree().?.quit(0);
    }
}
