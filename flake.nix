{
  description = "Nix package and nix-darwin module for Rift";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rift-src = {
      url = "github:acsandmann/rift/v0.5.6";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rift-src,
    }:
    let
      systems = [ "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          rift = pkgs.callPackage ./package.nix { inherit rift-src; };
        in
        {
          inherit rift;
          default = rift;
        }
      );

      checks = forAllSystems (system: {
        inherit (self.packages.${system}) rift;
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);

      overlays.default = final: _prev: {
        rift = final.callPackage ./package.nix { inherit rift-src; };
      };

      darwinModules = {
        rift = import ./modules/darwin.nix { inherit self; };
        default = self.darwinModules.rift;
      };
    };
}
