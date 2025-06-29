{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.mako;
in
{
  options.programs.mako = {
    enable = lib.mkEnableOption "A lightweight Wayland notification daemon";

    package = lib.mkPackageOption pkgs "mako" { };

    systemd.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The systemd target that will automatically start the mako service.
      '';
      default = "graphical-session.target";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd = {
      packages = [ cfg.package ];
      user.services.mako.wantedBy = [ cfg.systemd.target ];
    };
  };
}
