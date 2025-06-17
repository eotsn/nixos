{ config, pkgs, lib, ...}:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.05.tar.gz;
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

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };

    programs.eza = {
      enable = true;
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
