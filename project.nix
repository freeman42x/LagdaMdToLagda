{ mkDerivation, base, split, stdenv, text, turtle, directory, filepath }:
mkDerivation {
  pname = "LagdaMdToLagda";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base split text turtle directory filepath ];
  license = "unknown";
  hydraPlatforms = stdenv.lib.platforms.none;
}
