{
  lib,
  rustPlatform,
  rift-src,
}:

rustPlatform.buildRustPackage {
  pname = "rift";
  version = "0-unstable-${rift-src.lastModifiedDate or "unknown"}";

  src = rift-src;
  cargoHash = "sha256-wxymypJjczFqI9oivnVX/TOnR1KuupsaryQIQQVN7Gs=";

  cargoBuildFlags = [ "--bins" ];

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    license = lib.licenses.mit;
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
}
