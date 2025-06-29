{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.swayidle;
in
{
  options.programs.swayidle = {
    enable = lib.mkEnableOption "Idle management daemon for Wayland";

    package = lib.mkPackageOption pkgs "swayidle" { };

    events = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = ''
        List of swayidle events. See man:swayidle(1) for more information.
      '';
      default = [ ];
    };

    systemd.target = lib.mkOption {
      type = lib.types.str;
      description = ''
        The systemd target that will automatically start the swayidle service.
      '';
      default = "graphical-session.target";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.user.services.swayidle = {
      description = "Idle management daemon for Wayland";
      documentation = [ "man:swayidle(1)" ];
      wantedBy = [ cfg.systemd.target ];
      partOf = [ cfg.systemd.target ];
      after = [ cfg.systemd.target ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${lib.getExe cfg.package} ${lib.concatStringsSep " " cfg.events}";
        Restart = "always";
      };
    };
  };
}
