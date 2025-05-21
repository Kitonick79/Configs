{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nh.url = "github:nix-community/nh";

    hyprpanel = {
      # newer versions were broken
      url = "github:Jas-SinghFSU/HyprPanel?rev=2be9f1ef6c2df2ecf0eebe5a039e8029d8d151cd";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    hyprland,
    nh,
    hyprpanel,
    nixpkgs-wayland,
    catppuccin,
  } @ inputs: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        inputs.nixpkgs-wayland.overlay
        inputs.hyprpanel.overlay
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
