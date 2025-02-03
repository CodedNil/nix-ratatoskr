{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
    }@inputs:
    {
      nixosConfigurations = {
        ratatoskr = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            home-manager.nixosModules.home-manager
            ./hardware-configuration.nix
            ./common.nix
            ./dan/dan.nix
            ./media/media.nix
          ];
        };
      };
    };
}
