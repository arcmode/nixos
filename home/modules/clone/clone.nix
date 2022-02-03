# from https://github.com/shanesveller/nix-dotfiles-public-snapshot/blob/2c497990ee2a8944f97a5b59644ab77fe573ef79/tag-nix/config/nixpkgs/hm/data.nix

{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.clone;
  dag = config.lib.dag;

  cloneIfNotExists = target: repo: branch: ''
    if [ ! -e "${target}" ]; then
      $DRY_RUN_CMD ${pkgs.git}/bin/git clone \
        --branch "${branch}" \
        --recursive \
        -- \
        "${repo}" \
        "${target}"
    fi
  '';

  cloneScripts = lib.attrsets.mapAttrsToList
    (_name: attrs: cloneIfNotExists attrs.target attrs.repo attrs.branch)
    cfg.repos;
in {
  options.programs.clone.enable = mkEnableOption "Stateful Data";

  options.programs.clone.repos = mkOption {
    type = with types;
      attrsOf (submodule {
        options = {
          branch = mkOption { type = str; };
          repo = mkOption { type = str; };
          target = mkOption { type = path; };
        };
      });
  };

  config = mkIf cfg.enable {
    programs.git.enable = true;

    home.activation.cloneStatefulRepos = dag.entryAfter [ "installPackages" ]
      (builtins.concatStringsSep "\n" cloneScripts);
  };
}
