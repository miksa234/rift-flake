# rift-flake

Nix package and nix-darwin module for
[Rift](https://github.com/acsandmann/rift), pinned to `v0.5.6`.

The package targets Apple Silicon (`aarch64-darwin`).

## Usage

```nix
{
  inputs.rift.url = "github:your-name/rift-flake";
  inputs.rift.inputs.nixpkgs.follows = "nixpkgs";
}
```

```nix
{
  imports = [ inputs.rift.darwinModules.rift ];

  services.rift = {
    enable = true;
    settings = {
      settings.layout.mode = "scrolling";
      virtual_workspaces.enabled = true;
      keys."Alt + H".move_focus = "left";
    };
  };
}
```

`settings` is serialized directly to TOML. Alternatively, use an existing file:

```nix
services.rift = {
  enable = true;
  configFile = ./rift.toml;
};
```

`settings` and `configFile` are mutually exclusive.

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

Overriding `ProgramArguments` also makes the caller responsible for passing the
Rift executable and configuration path. The module does not invoke a shell or
load shell environment files.

Do not also run `rift service install`; that would create a second launchd
service. Rift requires macOS Accessibility permission.
