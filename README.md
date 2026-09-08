# rift-flake

Nix package and nix-darwin module for
[Rift](https://github.com/acsandmann/rift).

The default package follows the latest stable Rift release (currently v0.5.6).
Also available is `riftUnstable` package follows the upstream default branch.

## Usage

```nix
{
  inputs.rift.url = "github:miksa234/rift-flake";
  inputs.rift.inputs.nixpkgs.follows = "nixpkgs";
}
```

```nix
{
  imports = [ inputs.rift.darwinModules.rift ];

  services.rift = {
    enable = true;
    config = {
      settings.layout.mode = "scrolling";
      virtual_workspaces.enabled = true;
      keys."Alt + H".move_focus = "left";
    };
  };
}
```

`config` is serialized directly to TOML. Alternatively, use an existing file:

```nix
services.rift = {
  enable = true;
  configFile = ./rift.toml;
};
```

`config` and `configFile` are mutually exclusive.

The default package is the stable release. Newest upstream unstable is available through:

```nix
services.rift.package = inputs.rift.packages.${pkgs.system}.riftUnstable;
```

The module starts Rift as a user launchd agent. `serviceConfig` is merged over
the defaults and provides direct access to launchd, including
`ProgramArguments`:

```nix
services.rift.serviceConfig = {
  EnvironmentVariables.HOME = "/Users/me";
  StandardOutPath = "/tmp/rift.log";
  StandardErrorPath = "/tmp/rift.error.log";
};
```

The module does not invoke a shell or load shell environment files by default.
For a generic launcher or environment wrapper, prepend arguments with
`launchPrefix`. The module still appends the Rift executable and the generated
or supplied configuration path:

```nix
services.rift.launchPrefix = [
  (lib.getExe pkgs.zsh)
  "-c"
  ''source "$HOME/.zshenv"; exec "$@"''
  "--"
];
```

The prefix must execute the remaining arguments. `launchPrefix` is optional and
does not change the default launch behavior.
