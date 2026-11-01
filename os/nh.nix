{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.nh = {
    enable = true;
    package = inputs.nh.packages.x86_64-linux.default;
    clean.enable = true;
    clean.extraArgs = "--keep-since 10d --keep 3";
    # No attrpath: nh derives `nixosConfigurations.<hostname>` for `nh os`
    # and `homeConfigurations."<user>@<hostname>"` for `nh home`, which match
    # our outputs (`nixos` and `kit@nixos`). Pinning one attr here breaks the
    # other subcommand.
    flake = "/home/kit/nixos";
  };
}
