const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const godot_dep = b.dependency("godot", .{
        .target = target,
        .optimize = optimize,
    });

    const lib = b.addSharedLibrary(.{
        .name = "Template",
        .root_source_file = .{ .path = "src/ExtensionEntry.zig" },
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("godot", godot_dep.module("godot"));
    b.lib_dir = "./project/godot_zig/lib";
    b.installArtifact(lib);

    const run_cmd = b.addSystemCommand(&.{
        "godot", "--path", "./project",
    });
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "run with Godot");
    run_step.dependOn(&run_cmd.step);
}
