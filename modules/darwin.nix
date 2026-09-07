{ self }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.rift;
  toml = pkgs.formats.toml { };
  generatedConfig = toml.generate "rift-config.toml" cfg.settings;
  configFile = if cfg.configFile != null then cfg.configFile else generatedConfig;
in
{
  options.services.rift = {
    enable = lib.mkEnableOption "Rift macOS window manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.rift;
      defaultText = lib.literalExpression "inputs.rift.packages.${pkgs.system}.rift";
      description = "Rift package.";
    };

    settings = lib.mkOption {
      inherit (toml) type;
      default = { };
      description = "Settings converted to TOML.";
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Existing TOML config file.";
    };

    serviceConfig = lib.mkOption {
      type = lib.types.attrsOf lib.types.anything;
      default = { };
      description = "Launchd service configuration.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.configFile == null || cfg.settings == { };
        message = "services.rift.configFile and services.rift.settings are mutually exclusive";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.rift.serviceConfig = {
      ProgramArguments = [
        (lib.getExe cfg.package)
        "--config"
        (toString configFile)
      ];
      RunAtLoad = true;
      KeepAlive.SuccessfulExit = false;
    }
    // cfg.serviceConfig;
  };
}
