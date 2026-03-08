{...}: let
  dimAfterSeconds = 60 * 5;
  suspendAfterSeconds = 60 * 15;
in {
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "WLR_DRM_DEVICES=/dev/dri/card1 hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
        ignore_dbus_inhibit = false;
        ignore_systemd_inhibit = false;
      };
      listener = [
        {
          timeout = dimAfterSeconds;
          on-timeout = "brightnessctl -s set 15%";
          on-resume = "brightnessctl -r";
        }
        {
          timeout = dimAfterSeconds;
          on-timeout = "brightnessctl -sd platform::kbd_backlight set 0";
          on-resume = "brightnessctl -rd platform::kbd_backlight";
        }
        {
          timeout = suspendAfterSeconds;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
