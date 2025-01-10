{
  pkgs,
  ...
}: {
  wayland.windowManager.hyprland = {
  enable = true;
  xwayland.enable = true;
  settings = {
  "$mod" = "SUPER";
  bind = [
    "SUPER, T, exec, kitty"
    "SUPER, C, killactive"
    "SUPER, F, fullscreen"
  ];
  };
};
}
