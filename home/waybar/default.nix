{pkgs, ...}: {
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
        format = "{icon}";
        on-click = "activate";
        all-outputs = false;
      };

      clock = {
        format = "{:%H:%M  %a %d %b}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "  {usage}%";
        tooltip = false;
      };

      memory.format = "  {}%";
      temperature = {
        critical-threshold = 80;
        format = " {temperatureC}°C";
      };

      backlight = {
        format = "{icon} {percent}%";
        format-icons = ["" "" "" "" "" "" "" "" ""];
      };

      battery = {
        states = {
          warning = 30;
          critical = 15;
        };
        format = "{icon} {capacity}%";
        format-charging = " {capacity}%";
        format-plugged = " {capacity}%";
        format-icons = ["" "" "" "" ""];
      };

      network = {
        format-wifi = " {essid}";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰖪 offline";
        tooltip-format = "{ifname}: {ipaddr}/{cidr}";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-bluetooth = "{icon} {volume}%";
        format-muted = "";
        format-icons = {
          headphone = "";
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };

      tray = {
        icon-size = 18;
        spacing = 8;
      };
    };
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
