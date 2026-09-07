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
  effectiveConfig = if cfg.configFile != null then cfg.configFile else generatedConfig;
in
{
  options.services.rift = {
    enable = lib.mkEnableOption "Rift macOS window manager";

    package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.rift;
      defaultText = lib.literalExpression "inputs.rift.packages.${pkgs.system}.rift";
    };

    settings = lib.mkOption {
      inherit (toml) type;
      default = { };
    };

    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      example = lib.literalExpression "./rift.toml";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "--restore" ];
    };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
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
        (toString effectiveConfig)
      ]
      ++ cfg.extraArgs;
      RunAtLoad = true;
      KeepAlive = {
        SuccessfulExit = false;
      };
      ProcessType = "Interactive";
      EnvironmentVariables = cfg.environment;
      StandardOutPath = "/tmp/rift.log";
      StandardErrorPath = "/tmp/rift.error.log";
    };
  };
}
