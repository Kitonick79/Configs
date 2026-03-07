{pkgs, ...}: {
  programs.hyprpanel = {
    enable = true;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    # optional deps
    gpustat
    gpu-screen-recorder
    hyprpicker
    hyprsunset
    btop
    matugen
    swww
    grimblast
  ];
}
