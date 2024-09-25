const std = @import("std");
const Godot = @import("godot");
const GPA = std.heap.GeneralPurposeAllocator(.{});

var gpa = GPA{};

pub export fn extension_init(p_get_proc_address: Godot.GDExtensionInterfaceGetProcAddress, p_library: Godot.GDExtensionClassLibraryPtr, r_initialization: [*c]Godot.GDExtensionInitialization) Godot.GDExtensionBool {
    gpa = GPA{};
    const allocator = gpa.allocator();
    return Godot.registerPlugin(p_get_proc_address, p_library, r_initialization, allocator, &init, &deinit);
}

fn init(_: ?*anyopaque, p_level: Godot.GDExtensionInitializationLevel) void {
    if (p_level != Godot.GDEXTENSION_INITIALIZATION_SCENE) {
        return;
    }

    Godot.registerClass(Bootstub);
}

fn deinit(_: ?*anyopaque, p_level: Godot.GDExtensionInitializationLevel) void {
    if (p_level == Godot.GDEXTENSION_INITIALIZATION_CORE) {
        _ = gpa.deinit();
    }
}

pub const Bootstub = struct {
    const Self = @This();

    const Base = Godot.Node3D;
    pub usingnamespace Base;
    base: Base,

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
            self.get_tree().?.quit(0);
        }
    }
};
