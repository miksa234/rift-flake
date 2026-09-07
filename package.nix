{
  lib,
  rustPlatform,
  rift-src,
}:

rustPlatform.buildRustPackage {
  pname = "rift";
  version = "0.5.6";

  src = rift-src;
  cargoLock = {
    lockFile = "${rift-src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  cargoBuildFlags = [ "--bins" ];

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    license = lib.licenses.mit;
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
}
