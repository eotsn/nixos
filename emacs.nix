{ config, lib, pkgs, ... }:

let
  overrides = final: prev: {
    lsp-bridge = (
      prev.lsp-bridge.overrideAttrs (old: {
        src = pkgs.fetchFromGitHub {
          owner = "manateelazycat";
          repo = "lsp-bridge";
          rev = "b3e1e6fba2d0ca7602a63e09943a8c73cc9430af";
          hash = "sha256-K2OeD4N2P/gNOoOnEyA3nPJC8M6GUcAUYS2TzbScPSA=";
        };
      })
    );
  };
in
{
  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
    }))
  ];

  environment.systemPackages = with pkgs; [
    typescript-language-server
    tailwindcss-language-server
    vscode-langservers-extracted
  ];

  services.emacs = {
    enable = true;
    defaultEditor = true;
    package = with pkgs; (
      ((emacsPackagesFor emacs-unstable-pgtk).overrideScope overrides).withPackages (
        epkgs: with epkgs; [
          aidermacs
          apheleia
          avy
          cape
          consult
          diff-hl
          dockerfile-mode
          eat
          embark
          embark-consult
          expand-region
          forge
          go-mode
          gptel
          helpful
          indent-bars
          jinx
          jtsx
          lsp-bridge
          magit
          marginalia
          markdown-mode
          minions
          modus-themes
          move-text
          nix-ts-mode
          orderless
          perspective
          terraform-mode
          treesit-grammars.with-all-grammars
          vertico
          wgrep
          yaml-mode
          yasnippet
        ]
      )
    );
  };
}
