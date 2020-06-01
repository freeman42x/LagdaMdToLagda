{ mkDerivation, base, split, stdenv, text, turtle }:
mkDerivation {
  pname = "LagdaMdToLagda";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base split text turtle ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
