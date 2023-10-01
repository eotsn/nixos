{ inputs, config, lib, pkgs, ... }:

{
  imports = [
    ./programs/direnv.nix
    ./programs/fzf.nix
    ./programs/git.nix
    ./programs/i3.nix
    ./programs/lazygit.nix
    ./programs/redshift.nix
    ./programs/ssh.nix
    ./programs/tmux.nix
    ./programs/wezterm.nix
    ./programs/zsh.nix
    ./scripts/nix-direnv-init.nix
    ./scripts/tmux-sessionizer.nix
    ./scripts/xrvm.nix
  ];

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
    ];
    config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = (_: true);
    };
  };

  home.username = "eottosson";
  home.homeDirectory = "/home/eottosson";

  home.packages = with pkgs; [
    air
    firefox
    gcc
    gh
    gnumake
    go_1_21
    google-chrome
    google-cloud-sdk
    gopls
    gotools
    jq
    lua-language-server
    neovim-nightly
    nodejs_18
    obs-studio
    obsidian
    pavucontrol
    ripgrep
    slack
    spotify
    stylua
    tailwindcss
    tree-sitter
    vim
    vscode-langservers-extracted
    xclip
    zathura

    inputs.templ.packages."x86_64-linux".templ
    inputs.templ.packages."x86_64-linux".templ-docs
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "23.05";
}
