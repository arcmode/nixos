{ pkgs ? import <nixpkgs> { } }:
with pkgs;
mkShell {
  buildInputs = [
    python310
    python310Packages.pip
    python310Packages.virtualenv
  ];

  shellHook = ''
    # ...
  '';
}
