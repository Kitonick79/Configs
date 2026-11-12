{lib, ...}: let
  inherit (lib.generators) mkLuaInline;
in {
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.xwayland.enable = true;

  # Hyprland 0.55+ deprecates hyprlang in favour of Lua. Setting this explicitly
  # also silences home-manager's stateVersion-based default warning, and makes
  # catppuccin's `colors._var` render as a usable `local colors = ...`.
  wayland.windowManager.hyprland.configType = "lua";

  # eDP-1 is the anchor at 0x0 and every external places itself above it, so
  # adding a monitor touches only its own rule. Positions are logical pixels
  # (physical over scale), making eDP-1 1280x720; an external above it sits at
  # y = -(its logical height), and x = -(its logical width - 1280) / 2 to
  # centre the laptop beneath it. Both externals below are 2560 logical wide,
  # so both land on x = -640.
  #
  # Externals match on description rather than port: this laptop has a single
  # HDMI port, so both of them show up as HDMI-A-1 and the port name alone
  # cannot tell them apart. The serial is omitted from each description so the
  # rules match the model, not one specific unit.
  wayland.windowManager.hyprland.settings.monitor = [
    # AOC U27B3A, 27" 4K. `highres` takes the best mode the link can carry:
    # 3840x2160@60 over DisplayPort (via the USB-C port), but only @30 over
    # the EliteBook's HDMI port, which is 1.4 and cannot clock 4K faster.
    # That keeps one rule correct on either cable.
    {
      output = "desc:AOC U27B3A";
      mode = "highres";
      position = "-640x-1440";
      scale = 1.5;
    }
    # Dell U2917W, 29" 21:9 ultrawide. Native 2560x1080 at ~96 DPI, so it
    # wants no scaling.
    {
      output = "desc:Dell Inc. DELL U2917W";
      mode = "2560x1080@60";
      position = "-640x-1080";
      scale = 1;
    }
    {
      output = "eDP-1";
      mode = "1920x1080@60";
      position = "0x0";
      scale = 1.5;
    }
    # fallback for any other monitor
    {
      output = "";
      mode = "preferred";
      position = "auto";
      scale = 1;
    }
  ];

  # `_args` renders an attrset as a multi-argument Lua call: hl.env("K", "V")
  wayland.windowManager.hyprland.settings.env = [
    {_args = ["GDK_BACKEND" "wayland"];}
    {_args = ["GSK_RENDERER" "cairo"];}
    {_args = ["WLR_DRM_DEVICES" "/dev/dri/card1"];}
  ];

  # "Smart gaps": drop gaps and the border on a workspace holding a single
  # tiled, visible window (`w[tv1]`). Renders as one `hl.workspace_rule(...)`.
  wayland.windowManager.hyprland.settings.workspace_rule = [
    {
      workspace = "w[tv1]";
      gaps_out = 0;
      gaps_in = 0;
      border_size = 0;
    }
  ];

  wayland.windowManager.hyprland.settings.config = {
    # `colors` is the local that catppuccin's module defines above this call
    general.col = {
      active_border = mkLuaInline "{ colors = { colors.accent, colors.lavender }, angle = 45 }";
      inactive_border = mkLuaInline "colors.surface0";
    };

    input = {
      kb_layout = "us,ru";
      kb_variant = ",";
      kb_options = "grp:alt_space_toggle";
      sensitivity = -0.5;
      natural_scroll = true;
      # for mouse cursor
      # must click on window to move focus
      # follow_mouse = 2
      touchpad = {
        natural_scroll = true;
        scroll_factor = 0.5;
      };
    };
  };

  # Binds are code rather than data, so they read better as plain Lua than as
  # nested `_args` attrsets. This block is appended to hyprland.lua, so the
  # `colors` local and everything above is in scope here too.
  wayland.windowManager.hyprland.extraConfig = ''
    local mod = "SUPER"

    -- starting applications
    hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd("kitty"))
    hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("anyrun"))
    -- hl.bind(mod .. " + E", hl.dsp.exec_cmd("ghostty -e yazi"))

    -- window management
    hl.bind(mod .. " + Q", hl.dsp.window.close())
    hl.bind(mod .. " + M", hl.dsp.exit())
    hl.bind(mod .. " + S", hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
    hl.bind(mod .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))

    -- move the active window to the next position
    hl.bind(mod .. " + N", hl.dsp.window.swap({ next = true }))
    -- make the active window the main
    hl.bind(mod .. " + A", hl.dsp.layout("togglesplit"))

    -- screenshots
    hl.bind("Print", hl.dsp.exec_cmd("grim - | wl-copy"))
    hl.bind("SHIFT + Print", hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy]]))

    -- brightness control
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 10%+"))
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"))

    -- volume control (for pipewire / wireplumber)
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"))
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"))
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"))

    -- disable notifications
    -- TODO: find how to do it with waybar
    -- hl.bind(mod .. " + SHIFT + N", hl.dsp.exec_cmd("makoctl mode -t do-not-disturb"))

    -- lock screen. On ESCAPE rather than L, which steps workspaces below.
    hl.bind(mod .. " + ESCAPE", hl.dsp.exec_cmd("loginctl lock-session"))

    -- hyprland management
    hl.bind(mod .. " + R", hl.dsp.exec_cmd("hyprctl reload"))

    -- navigation between windows
    hl.bind(mod .. " + left", hl.dsp.focus({ direction = "left" }))
    hl.bind(mod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mod .. " + up", hl.dsp.focus({ direction = "up" }))
    hl.bind(mod .. " + down", hl.dsp.focus({ direction = "down" }))

    -- focus the other monitor. `+1` cycles rather than taking a direction, so
    -- it reads as a toggle with two attached and still reaches a third.
    hl.bind(mod .. " + D", hl.dsp.focus({ monitor = "+1" }))
    -- send the active window to the other monitor, cycling the same way.
    -- Focus travels with the window, so this lands you where it went.
    hl.bind(mod .. " + SHIFT + D", hl.dsp.window.move({ monitor = "+1" }))

    -- workspace selection, and moving the active window to a workspace
    for i = 1, 10 do
      local key = i % 10 -- 10 maps to key 0
      hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = i }))
      hl.bind(mod .. " + CTRL + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    -- step through workspaces, by key and by scroll. `e-1`/`e+1` move to the
    -- previous/next workspace that exists, skipping empty numbers.
    hl.bind(mod .. " + H", hl.dsp.focus({ workspace = "e-1" }))
    hl.bind(mod .. " + L", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

    -- groups (tabbed containers)
    hl.bind(mod .. " + g", hl.dsp.group.toggle())
    hl.bind(mod .. " + tab", hl.dsp.group.next())

    -- move and resize windows with the mouse cursor
    hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mod .. " + SHIFT + mouse:272", hl.dsp.window.resize(), { mouse = true })
  '';
}
