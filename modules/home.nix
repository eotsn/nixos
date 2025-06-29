{ config, pkgs, lib, ...}:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in
{
  imports =
    [ # Enable the NixOS Home Manager module.
      (import "${home-manager}/nixos")
    ];

  # Tell Home Manager to use the global pkgs that is configured via the system
  # level nixpkgs options. This saves an extra nixpkgs evaluation.
  home-manager.useGlobalPkgs = true;

  home-manager.users.erico = { pkgs, ... }: {
    home.packages = with pkgs; [
      git
      nodejs_22
      pnpm
      unzip
    ];

    programs.btop = {
      enable = true;
      settings = {
        color_theme = "catppuccin_mocha";
        theme_background = false;
        vim_keys = true;
      };
    };

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };

    programs.eza = {
      enable = true;
      icons = "auto";
    };

    programs.fd = {
      enable = true;
    };

    programs.fish = {
      enable = true;
      plugins = [
        {
          name = "hydro";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "hydro";
            rev = "75ab7168a35358b3d08eeefad4ff0dd306bd80d4";
            sha256 = "QYq4sU41/iKvDUczWLYRGqDQpVASF/+6brJJ8IxypjE=";
          };
        }
      ];
    };

    programs.fzf = {
      enable = true;
      colors = {
        "bg" = "#1E1E2E";
        "bg+" = "#313244";
        "border" = "#313244";
        "fg" = "#CDD6F4";
        "fg+" = "#CDD6F4";
        "header" = "#F38BA8";
        "hl" = "#F38BA8";
        "hl+" = "#F38BA8";
        "info" = "#CBA6F7";
        "label" = "#CDD6F4";
        "marker" = "#B4BEFE";
        "pointer" = "#F5E0DC";
        "prompt" = "#CBA6F7";
        "selected-bg" = "#45475A";
        "spinner" = "#F5E0DC";
      };
    };

    programs.jq = {
      enable = true;
    };

    programs.ripgrep = {
      enable = true;
    };

    programs.yazi = {
      enable = true;
    };

    programs.zoxide = {
      enable = true;
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager
    # release introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you
    # do want to update the value, then make sure to first check the Home
    # Manager release notes.
    home.stateVersion = "25.05"; # Please read the comment before changing.

  };
}
