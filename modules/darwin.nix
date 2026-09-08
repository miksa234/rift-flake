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
  generatedConfig = toml.generate "rift-config.toml" cfg.config;
  configFile =
    if cfg.configFile != null then
      cfg.configFile
    else if cfg.config != { } then
      generatedConfig
    else
      "${cfg.package}/share/rift/rift.default.toml";
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

    config = lib.mkOption {
      inherit (toml) type;
      default = { };
      description = "Config converted to TOML.";
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

    launchPrefix = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Arguments placed before Rift's generated launch arguments.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.configFile == null || cfg.config == { };
        message = "services.rift.configFile and services.rift.config are mutually exclusive";
      }
    ];

    environment.systemPackages = [ cfg.package ];

    launchd.user.agents.rift.serviceConfig = {
      ProgramArguments = cfg.launchPrefix ++ [
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
