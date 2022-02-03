{ lib, python3Packages }:
with python3Packages;
buildPythonApplication {
  pname = "nixos-installer-service";
  version = "1.0";

  propagatedBuildInputs = [ flask ];

  src = ./.;
}
