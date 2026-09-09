{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh.url = "github:nix-community/nh";

    catppuccin.url = "github:catppuccin/nix";

    claude-desktop.url = "github:k3d3/claude-desktop-linux-flake";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    nh,
    anyrun,
    #hyperidle,
    nixpkgs-wayland,
    catppuccin,
    claude-desktop,
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        inputs.nixpkgs-wayland.overlay
      ];
      config = {
        allowUnfree = true;
        allowUnfreePredicate = _: true;
      };
    };
  in {
    homeConfigurations."kit@nixos" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};
      modules = [
        ./home
        catppuccin.homeModules.catppuccin
        ];
    };
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system pkgs;
      specialArgs = {inherit inputs;};
      modules = [
        ./os
        home-manager.nixosModules.home-manager
        catppuccin.nixosModules.catppuccin
      ];
    };
    formatter = {
      x86_64-linux = pkgs.alejandra;
    };
  };
}
