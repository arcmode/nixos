{
  description = "NixOS Installer Service - NOIS";

  inputs = {
    nixpkgs.url      = "github:nixos/nixpkgs/nixos-unstable";
    # rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url  = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, ... } @ inputs:
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        pkgs = inputs.nixpkgs.legacyPackages.${system};
      in
      {
        devShell = import ./shell.nix { inherit pkgs; };
      }
    );
}
