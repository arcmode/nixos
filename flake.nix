{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    # nix-darwin.url = "github:lnl7/nix-darwin";
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations.omen = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/omen/configuration.nix
        ./configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.david = import ./home.nix;
        }
      ];
    };
  };
}
