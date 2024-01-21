const std = @import("std");
const Godot = @import("Godot");
const Self = @This();
pub usingnamespace Godot.Node3D;

godot_object: *Godot.Node3D,

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
        self.get_tree().quit(0);
    }
}
