# Racket with the `sicp` collection available, so `#lang sicp` works.
#
# nixpkgs has no Racket package set, so the collection is built from source
# here and exposed to Racket through PLTCOLLECTS. This replaces the imperative
# `raco pkg install sicp`, which installs into ~/.local/share/racket/<version>
# and breaks whenever the Racket version changes.
{pkgs, ...}: let
  # https://github.com/sicp-lang/sicp — provides the sicp, sicp-pict and
  # sicp-doc collections. Its deps (base, draw-lib, r5rs-lib, rackunit-lib,
  # snip-lib) all ship with the full racket distribution, so there is nothing
  # further to fetch.
  sicpCollects = pkgs.stdenv.mkDerivation {
    pname = "racket-sicp";
    version = "1.0-unstable-2024-06-17";

    src = pkgs.fetchFromGitHub {
      owner = "sicp-lang";
      repo = "sicp";
      rev = "5ba7b852855cf107892244b37d6a1ffbef14d595";
      hash = "sha256-b7Bdw8AhV/scJtg5Ir0hPqmr/i4Yfhl6BKg19dGHBcA=";
    };

    nativeBuildInputs = [pkgs.racket];
    dontBuild = true;

    installPhase = ''
      runHook preInstall

      collects=$out/share/racket/collects
      mkdir -p $collects
      cp -r sicp sicp-pict sicp-doc $collects/

      # Precompile to .zo so the store copy is not recompiled on every run.
      # raco wants a writable HOME for its info cache.
      export HOME=$TMPDIR
      PLTCOLLECTS=":$collects" raco make -j $NIX_BUILD_CORES \
        $collects/sicp/main.rkt \
        $collects/sicp/lang/reader.rkt \
        $collects/sicp-pict/main.rkt

      runHook postInstall
    '';
  };

  racket-with-sicp = pkgs.symlinkJoin {
    name = "racket-with-sicp-${pkgs.racket.version}";
    paths = [pkgs.racket];
    nativeBuildInputs = [pkgs.makeWrapper];

    # The leading ":" is load-bearing: an *empty* entry in PLTCOLLECTS is what
    # tells Racket to also search its built-in collection paths. This must be
    # --set rather than --prefix, because makeWrapper's --prefix strips leading
    # and trailing colons and would silently drop the built-in collections.
    postBuild = ''
      for prog in $out/bin/*; do
        wrapProgram "$prog" \
          --set PLTCOLLECTS ":${sicpCollects}/share/racket/collects"
      done
    '';
  };
in {
  environment.systemPackages = [racket-with-sicp];
}
