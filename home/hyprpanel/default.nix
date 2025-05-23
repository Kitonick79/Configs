{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.hyprpanel.homeManagerModules.hyprpanel];

  programs.hyprpanel = {
    # enable the overlay
    overlay.enable = true;
    # Enable the module.
    # Default: false
    enable = true;

    # Add '/nix/store/.../hyprpanel' to your
    # Hyprland config 'exec-once'.
    # Default: false
    hyprland.enable = true;

    # Fix the overwrite issue with HyprPanel.
    # See below for more information.
    # Default: false
    overwrite.enable = true;

    # Import a theme from './themes/*.json'.
    # Default: ""
    # theme = "cattpuccin_mocha";

    # Override the final config with an arbitrary set.
    # Useful for overriding colors in your selected theme.
    # Default: {}
    # override = {
    #   theme.bar.menus.text = "#123ABC";
    # };

    # Configure bar layouts for monitors.
    # See 'https://hyprpanel.com/configuration/panel.html'.
    # Default: null
    #settings = {
    # layout = {
    #   "bar.layouts" = {
    #     "0" = {
    #       "left" = ["dashboard" "workspaces" "windowtitle"];
    #       "middle" = ["media"];
    #       "right" = ["battery" "network" "clock"];
    #     };
    #   };  
    # };
  };
  
  home.packages = with pkgs; [
    # optional deps
    gpustat
    gpu-screen-recorder
    hyprpicker
    hyprsunset
    hypridle
    btop
    matugen
    swww
    grimblast
  ];
}
