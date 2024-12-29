const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const godot_path = b.option([]const u8, "godot", "Path to the Godot binary") orelse "godot";

    const godot_dep = b.dependency("godot", .{
        .target = target,
        .optimize = optimize,
        .godot = godot_path,

        // This is the default value, so could be omitted. If you want, you can change it to "double".
        // You should hardcode this for your project, rather than exposing it as a build option like the godot path.
        .precision = @as([]const u8, "float"),
    });

    const lib = b.addSharedLibrary(.{
        .name = "Template",
        .root_source_file = b.path("src/ExtensionEntry.zig"),
        .target = target,
        .optimize = optimize,
    });
    lib.root_module.addImport("godot", godot_dep.module("godot"));
    b.lib_dir = "./project/godot_zig/lib";
    b.installArtifact(lib);

    const run_cmd = b.addSystemCommand(&.{
        godot_path, "--path", "./project",
    });
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "run with Godot");
    run_step.dependOn(&run_cmd.step);
}
