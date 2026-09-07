# rift-flake

Nix package and nix-darwin module for [Rift](https://github.com/acsandmann/rift).

## Usage

Add the flake input:

```nix
{
  inputs.rift.url = "github:your-name/rift-flake";
  inputs.rift.inputs.nixpkgs.follows = "nixpkgs";
}
```

Import and configure the module:

```nix
{
  imports = [ inputs.rift.darwinModules.rift ];

  services.rift = {
    enable = true;
    settings = {
      settings = {
        animate = true;
        layout.mode = "scrolling";
      };
      virtual_workspaces = {
        enabled = true;
        default_workspace_count = 4;
      };
      keys."Alt + H".move_focus = "left";
    };
  };
}
```

`settings` and `configFile` are mutually exclusive.

The module manages Rift directly as a nix-darwin user launchd agent.
