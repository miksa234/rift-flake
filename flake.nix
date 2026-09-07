{
  description = "Nix package and nix-darwin module for Rift";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    rift-src = {
      url = "github:acsandmann/rift";
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

      overlays.default = final: _prev: {
        rift = final.callPackage ./package.nix { inherit rift-src; };
      };

      darwinModules = {
        rift = import ./modules/darwin.nix { inherit self; };
        default = self.darwinModules.rift;
      };
    };
}
