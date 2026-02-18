{
  description = "Home Manager config";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    untracked-martinator = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/untracked-martinator.nix";
      flake = false;
    };
    untracked-opstop = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/untracked-opstop.nix";
      flake = false;
    };
    untracked-t480 = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/untracked-t480.nix";
      flake = false;
    };
    consul-tunnels = {
      type = "file";
      url = "file:///home/maarten/.config/nixpkgs/consul-tunnels.nix";
      flake = false;
    };
    firenvim = {
      url = "github:glacambre/firenvim/0.2.16";
      flake = false;
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      homeConfigurations.martinator = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homes/martinator.nix
          (import inputs.untracked-martinator)
        ];

        extraSpecialArgs = inputs;
      };

      homeConfigurations.opstop = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homes/opstop.nix
          (import inputs.untracked-opstop)
          (import inputs.consul-tunnels)
        ];

        extraSpecialArgs = inputs;
      };

      homeConfigurations.t480 = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./homes/t480.nix
          (import inputs.untracked-t480)
        ];

        extraSpecialArgs = inputs;
      };
    };
}
