{
  lib,
  rustPlatform,
  rift-src,
  version,
}:

rustPlatform.buildRustPackage {
  pname = "rift";
  inherit version;

  src = rift-src;
  cargoLock = {
    lockFile = "${rift-src}/Cargo.lock";
    allowBuiltinFetchGit = true;
  };

  cargoBuildFlags = [ "--bins" ];
  doCheck = false;

  postInstall = ''
    install -Dm644 rift.default.toml $out/share/rift/rift.default.toml
  '';

  meta = {
    description = "Tiling window manager for macOS";
    homepage = "https://github.com/acsandmann/rift";
    license = lib.licenses.mit;
    mainProgram = "rift";
    platforms = lib.platforms.darwin;
  };
}
