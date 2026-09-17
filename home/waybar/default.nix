{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      spacing = 4;

      modules-left = ["hyprland/workspaces" "hyprland/submap"];
      modules-center = ["clock"];
      modules-right = [
        "tray"
        "pulseaudio"
        "network"
        "cpu"
        "memory"
        "temperature"
        "backlight"
        "battery"
      ];

      "hyprland/workspaces" = {
        format = "{id}";
        on-click = "activate";
        all-outputs = false;
      };

      clock = {
        format = "  {:%H:%M  %a %d %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "  {usage}%";
        tooltip = false;
      };

      memory.format = "󰍛  {}%";
      temperature = {
        critical-threshold = 80;
        format = "  {temperatureC}°C";
      };

      backlight = {
        format = "{icon}  {percent}%";
        format-icons = ["󰃛" "󰃜" "󰃝" "󰃞" "󰃟" "󰃠" "󰃡"];
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon}  {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = "  {essid}";
        format-ethernet = "  {ipaddr}";
        format-disconnected = "  offline";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{icon}  {volume}%";
        format-bluetooth = "{icon}  {volume}%";
        format-muted = "  muted";
        format-icons = {
          headphone = "";
          default = ["" ""];
        };
        on-click = "pavucontrol";
      };

      tray = {
        icon-size = 18;
        spacing = 8;
      };
    };

    # Catppuccin's HM module prepends the palette (@base, @text, @mauve, @accent…)
    # with mkBefore, but only defines the colors — it applies none of them.
    # mkAfter keeps that import first and puts the actual rules here.
    style = lib.mkAfter ''
      * {
        font-family: "JetBrainsMono Nerd Font", sans-serif;
        font-size: 13px;
        font-weight: 500;
        min-height: 0;
        border: none;
        border-radius: 0;
      }

      window#waybar {
        background: @base;
        color: @text;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      tooltip {
        background: @mantle;
        border: 1px solid @surface1;
        border-radius: 8px;
      }

      tooltip label {
        color: @text;
        padding: 4px;
      }

      /* modules */
      #workspaces,
      #submap,
      #clock,
      #tray,
      #pulseaudio,
      #network,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #battery {
        background: @surface0;
        color: @text;
        padding: 0 10px;
        margin: 4px 0;
        border-radius: 8px;
      }

      #workspaces {
        padding: 0 4px;
        margin-left: 6px;
      }

      #workspaces button {
        color: @overlay0;
        padding: 0 8px;
        margin: 2px 2px;
        border-radius: 6px;
        background: transparent;
        transition: background 150ms ease, color 150ms ease;
      }

      #workspaces button:hover {
        background: @surface1;
        color: @text;
        box-shadow: none;
        text-shadow: none;
      }

      #workspaces button.active {
        background: @accent;
        color: @crust;
      }

      #workspaces button.urgent {
        background: @red;
        color: @crust;
      }

      #submap {
        background: @accent;
        color: @crust;
      }

      #clock {
        background: @surface0;
        color: @accent;
        font-weight: 700;
      }

      #tray {
        padding: 0 8px;
      }

      #tray menu {
        background: @mantle;
        color: @text;
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
      }

      /* accent each right-hand module so they read apart at a glance */
      #pulseaudio   { color: @sky; }
      #network      { color: @sapphire; }
      #cpu          { color: @blue; }
      #memory       { color: @lavender; }
      #temperature  { color: @green; }
      #backlight    { color: @yellow; }
      #battery      { color: @teal; margin-right: 6px; }

      #pulseaudio.muted,
      #network.disconnected {
        color: @overlay1;
      }

      #temperature.critical {
        background: @red;
        color: @crust;
      }

      #battery.warning:not(.charging) {
        color: @peach;
      }

      #battery.critical:not(.charging) {
        background: @red;
        color: @crust;
      }

      #battery.charging,
      #battery.plugged {
        color: @green;
      }
    '';
  };

  home.packages = with pkgs; [
    # tools kept from previous panel setup
    gpustat
    gpu-screen-recorder
    hyprpicker
    hyprsunset
    btop
    grimblast
    bluez
    pavucontrol
  ];
}
