{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, stdenv, text }:
      mkDerivation {
        pname = "LagdaMdToLagda";
        version = "0.1.0.0";
        src = ./.;
        isLibrary = false;
        isExecutable = true;
        executableHaskellDepends = [ base text ];
        license = "unknown";
        hydraPlatforms = stdenv.lib.platforms.none;
      };
  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  (if pkgs.lib.inNixShell then drv.env else drv).overrideAttrs (_: {
  shellHook = ''
    PATH="$PATH:${pkgs.ghc}/bin:${pkgs.cabal-install}/bin:${pkgs.atom}/bin:${
      ((import
        (fetchTarball "https://github.com/infinisil/all-hies/tarball/master")
        { }).selection { selector = p: { inherit (p) ghc865; }; })
    }/bin"'';
})
