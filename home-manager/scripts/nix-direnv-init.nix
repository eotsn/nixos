{ pkgs, ... }:

let
  nix-direnv-init = pkgs.writeShellScriptBin "nix-direnv-init" ''
    cat <<EOF > shell.nix
    { pkgs ? import <nixpkgs> {} }:
    pkgs.mkShell {
      nativeBuildInputs = with pkgs.buildPackages; [
      ];
    }
    EOF
    echo "use nix" >> .envrc
    direnv allow
  '';
in
{
  home.packages = [ nix-direnv-init ];
}
