const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});
    const precision = b.option([]const u8, "precision", "double") orelse "float";
    const arch = b.option([]const u8, "arch", "32") orelse "64";
    const godot_path = b.option([]const u8, "godot", "godot path") orelse "godot";
    const godot_zig_build = @import("godot-zig/build.zig");
    _ = godot_zig_build.createBindStep(b, target, precision, arch, godot_path);

    const lib = b.addSharedLibrary(.{
        .name = "Template",
        .root_source_file = .{ .path = "src/ExtensionEntry.zig" },
        .target = target,
        .optimize = optimize,
    });

    const api_path = "./godot-zig/src/api";

    const mod = b.createModule(.{ .root_source_file = .{ .path = api_path ++ "/Godot.zig" } });
    mod.addIncludePath(.{ .path = api_path });

    const build_options = b.addOptions();
    build_options.addOption([]const u8, "precision", precision);
    build_options.addOption([]const u8, "arch", arch);
    mod.addOptions("build_options", build_options);

    lib.root_module.addImport("Godot", mod);

    lib.addIncludePath(.{ .path = api_path });
    lib.linkLibC();
    b.lib_dir = "./project/godot_zig/lib";
    b.installArtifact(lib);

    const run_cmd = b.addSystemCommand(&.{
        "godot",
        "--path",
        "./project",
        "--resolution",
        "1920x1080",
    });
    run_cmd.step.dependOn(b.getInstallStep());
    const run_step = b.step("run", "run with Godot");
    run_step.dependOn(&run_cmd.step);
}
