{ config, pkgs, lib, stdenv, ... }:

{
  imports = [
    ./home/modules/clone/clone.nix
  ];
  home.username = "david";
  home.homeDirectory = "/home/david";
  home.stateVersion = "22.05";
  programs.home-manager.enable = true;

  xdg.enable = true;

  programs.git = {
    enable = true;
    userName = "David Rojas Camaggi";
    userEmail = "drojascamaggi@gmail.com";
  };

  programs.clone = {
    enable = true;
    repos = {
      spacemacs = {
        branch = "develop";
        repo = "https://github.com/syl20bnr/spacemacs.git";
        target = "${config.xdg.configHome}/emacs";
      };
      dot = {
        branch = "master";
        repo = "https://github.com/arcmode/dot.git";
        target = "/home/david/code/dot";
      };
    };
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
         "git"
         "tmux"
      ];
      theme = "robbyrussell";
    };
    initExtra = ''
    ${pkgs.neofetch}/bin/neofetch;
    ${pkgs.fortune}/bin/fortune | ${pkgs.cowsay}/bin/cowsay | ${pkgs.lolcat}/bin/lolcat;
    '';

    sessionVariables = {
      # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/tmux#configuration-variables
      # automatically start tmux
      ZSH_TMUX_AUTOSTART = "true";
      ZSH_TMUX_CONFIG = "$XDG_CONFIG_HOME/tmux/tmux.conf";
    };
  };

  programs.gh = {
    enable = true;
    enableGitCredentialHelper = true;
  };

  programs.tmux = {
    aggressiveResize = true;
    baseIndex = 1;
    enable = true;
    terminal = "screen-256color";
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 0;
    historyLimit = 50000;
    keyMode = "emacs";
    shortcut = "Space";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      {
	      plugin = dracula;
	      extraConfig = ''
		    set -g @dracula-show-battery false
		    set -g @dracula-show-powerline true
		    set -g @dracula-refresh-rate 10

        bind-key R source-file $XDG_CONFIG_HOME/tmux/tmux.conf \; display-message "$XDG_CONFIG_HOME/tmux/tmux.conf reloaded"
	      '';
      }
    ];

    extraConfig = ''
	  set -g mouse on
    '';
  };

  home.file.".config/alacritty/alacritty.yaml".text = ''
    window:
      decorations: none
      startup_mode: Fullscreen
    key_bindings:
    - { key: F11, action: ToggleFullscreen }
  '';
}
