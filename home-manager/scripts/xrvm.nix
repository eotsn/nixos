{ pkgs, ... }:

let
  xrvm = pkgs.writeShellScriptBin "xrvm" ''
    while getopts ":adh" opt; do
      case ''${opt} in
        a)
          xrandr --setmonitor DP-2-1 1280/294x1600/183+0+0 DP-2
          xrandr --setmonitor DP-2-2 2560/586x1600/183+1280+0 none
          ;;
        d)
          xrandr --delmonitor DP-2-2
          xrandr --delmonitor DP-2-1
          ;;
        h | *)
          echo "Usage: xrvm [-a] [-d]"
          ;;
      esac
    done
  '';
in
{
  home.packages = [ xrvm ];
}
