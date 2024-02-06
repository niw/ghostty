const std = @import("std");

const Config = @import("config/Config.zig");
const Action = @import("cli/action.zig").Action;
const ListFontsConfig = @import("cli/list_fonts.zig").Config;
const ShowConfigOptions = @import("cli/show_config.zig").Options;
const ListKeybindsOptions = @import("cli/list_keybinds.zig").Options;

pub fn main() !void {
    const writer = std.io.getStdOut().writer();

    {
        try writer.writeAll("set -l commands \"");
        var count: usize = 0;
        inline for (@typeInfo(Action).Enum.fields) |field| {
            if (comptime std.mem.eql(u8, "help", field.name)) continue;
            if (comptime std.mem.eql(u8, "version", field.name)) continue;
            if (count > 0) try writer.writeAll(" ");
            try writer.writeAll("+");
            try writer.writeAll(field.name);
            count += 1;
        }
        try writer.writeAll("\"\n");
    }

    try writer.writeAll("complete -c ghostty -f\n");

    try writer.writeAll("complete -c ghostty -l help -f\n");
    try writer.writeAll("complete -c ghostty -n \"not __fish_seen_subcommand_from $commands\" -l version -f\n");

    inline for (@typeInfo(Config).Struct.fields) |field| {
        if (field.name[0] == '_') continue;

        try writer.writeAll("complete -c ghostty -n \"not __fish_seen_subcommand_from $commands\" -l ");
        try writer.writeAll(field.name);
        try writer.writeAll(if (field.type != bool) " -r" else " ");
        if (std.mem.startsWith(u8, field.name, "font-family"))
            try writer.writeAll(" -f  -a \"(ghostty +list-fonts | grep '^[A-Z]')\"")
        else if (std.mem.eql(u8, "theme", field.name))
            try writer.writeAll(" -f -a \"(ghostty +list-themes)\"")
        else if (std.mem.eql(u8, "working-directory", field.name))
            try writer.writeAll(" -f -k -a \"(__fish_complete_directories)\"")
        else {
            try writer.writeAll(if (field.type != Config.RepeatablePath) " -f" else " -F");
            switch (@typeInfo(field.type)) {
                .Bool => try writer.writeAll(" -a \"true false\""),
                .Enum => |info| {
                    try writer.writeAll(" -a \"");
                    inline for (info.fields, 0..) |f, i| {
                        if (i > 0) try writer.writeAll(" ");
                        try writer.writeAll(f.name);
                    }
                    try writer.writeAll("\"");
                },
                .Struct => |info| {
                    if (!@hasDecl(field.type, "parseCLI") and info.layout == .Packed) {
                        try writer.writeAll(" -a \"");
                        inline for (info.fields, 0..) |f, i| {
                            if (i > 0) try writer.writeAll(" ");
                            try writer.writeAll(f.name);
                            try writer.writeAll(" no-");
                            try writer.writeAll(f.name);
                        }
                        try writer.writeAll("\"");
                    }
                },
                else => {},
            }
        }
        try writer.writeAll("\n");
    }

    {
        try writer.writeAll("complete -c ghostty -n \"string match -q -- '+*' (commandline -pt)\" -f -a \"");
        var count: usize = 0;
        inline for (@typeInfo(Action).Enum.fields) |field| {
            if (comptime std.mem.eql(u8, "help", field.name)) continue;
            if (comptime std.mem.eql(u8, "version", field.name)) continue;
            if (count > 0) try writer.writeAll(" ");
            try writer.writeAll("+");
            try writer.writeAll(field.name);
            count += 1;
        }
        try writer.writeAll("\"\n");
    }

    inline for (@typeInfo(ListFontsConfig).Struct.fields) |field| {
        if (field.name[0] == '_') continue;
        try writer.writeAll("complete -c ghostty -n \"__fish_seen_subcommand_from +list-fonts\" -l ");
        try writer.writeAll(field.name);
        try writer.writeAll(if (field.type != bool) " -r" else " ");
        try writer.writeAll(" -f");
        switch (@typeInfo(field.type)) {
            .Bool => try writer.writeAll(" -a \"true false\""),
            .Enum => |info| {
                try writer.writeAll(" -a \"");
                inline for (info.fields, 0..) |f, i| {
                    if (i > 0) try writer.writeAll(" ");
                    try writer.writeAll(f.name);
                }
                try writer.writeAll("\"");
            },
            else => {},
        }
        try writer.writeAll("\n");
    }

    inline for (@typeInfo(ShowConfigOptions).Struct.fields) |field| {
        if (field.name[0] == '_') continue;
        try writer.writeAll("complete -c ghostty -n \"__fish_seen_subcommand_from +show-config\" -l ");
        try writer.writeAll(field.name);
        try writer.writeAll(if (field.type != bool) " -r" else " ");
        try writer.writeAll(" -f");
        switch (@typeInfo(field.type)) {
            .Bool => try writer.writeAll(" -a \"true false\""),
            .Enum => |info| {
                try writer.writeAll(" -a \"");
                inline for (info.fields, 0..) |f, i| {
                    if (i > 0) try writer.writeAll(" ");
                    try writer.writeAll(f.name);
                }
                try writer.writeAll("\"");
            },
            else => {},
        }
        try writer.writeAll("\n");
    }

    inline for (@typeInfo(ListKeybindsOptions).Struct.fields) |field| {
        if (field.name[0] == '_') continue;
        try writer.writeAll("complete -c ghostty -n \"__fish_seen_subcommand_from +list-keybinds\" -l ");
        try writer.writeAll(field.name);
        try writer.writeAll(if (field.type != bool) " -r" else " ");
        try writer.writeAll(" -f");
        switch (@typeInfo(field.type)) {
            .Bool => try writer.writeAll(" -a \"true false\""),
            .Enum => |info| {
                try writer.writeAll(" -a \"");
                inline for (info.fields, 0..) |f, i| {
                    if (i > 0) try writer.writeAll(" ");
                    try writer.writeAll(f.name);
                }
                try writer.writeAll("\"");
            },
            else => {},
        }
        try writer.writeAll("\n");
    }
}
