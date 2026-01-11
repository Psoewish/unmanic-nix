{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.services.unmanic;
in
{
  options.services.unmanic = {
    enable = lib.mkEnableOption "Unmanic media library optimizer";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.callPackage ./package.nix { };
      description = "The Unmanic package to use.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/unmanic";
      description = "The directory where Unmanic will store its data.";
    };

    port = lib.mkOption {
      type = lib.types.int;
      default = 8888;
      description = "The port on which Unmanic will listen.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "unmanic";
      description = "The user under which Unmanic will run.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "unmanic";
      description = "The group under which Unmanic will run.";
    };

    extraGroups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "video"
        "render"
      ];
      description = "Additional groups under which Unmanic will run (useful for hardware access)";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firwall for Unmanic";
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      inherit (cfg) group extraGroups;
      isSystemUser = true;
      home = cfg.dataDir;
    };

    users.groups.${cfg.group} = { };

    systemd.services.unmanic = {
      description = "Unmanic";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = {
        HOME = cfg.dataDir;
      };

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = cfg.group;
        ExecStart = "${cfg.package}/bin/unmanic --port ${toString cfg.port}";
        StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/unmanic") "unmanic";
        WorkingDirectory = cfg.dataDir;
        Restart = "on-failure";
        RestartSec = 5;

        # Hardening
        NoNewPrivileges = true;
        PrivateTmp = true;
        ProtectHome = true;
      };
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };
  };
}
