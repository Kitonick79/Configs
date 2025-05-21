{pkgs, ...}: {
  home.packages = with pkgs; [
    anyrun
  ];
  # programs.anyrun = {
  #   enable = true;
  # };
}
