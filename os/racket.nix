# Racket with the `sicp` collection available, so `#lang sicp` works.
#
# nixpkgs has no Racket package set, so the collection is built from source
# here and exposed to Racket through PLTCOLLECTS. This replaces the imperative
# `raco pkg install sicp`, which installs into ~/.local/share/racket/<version>
# and breaks whenever the Racket version changes.
{pkgs, ...}: let
  # https://github.com/sicp-lang/sicp — upstream ships the sicp, sicp-pict and
  # sicp-doc collections. Its deps (base, draw-lib, r5rs-lib, rackunit-lib,
  # snip-lib) all come with the full racket distribution, so there is nothing
  # further to fetch.
  #
  # sicp-doc is deliberately left out. It carries only Scribble sources, and
  # building those here would pull in the doc toolchain for no runtime gain.
  # It is also the only one of the three with an info.rkt, which makes
  # `raco setup` want to write an info-domain table into this derivation --
  # impossible in the read-only store, so it would fail every `raco setup`.
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
      cp -r sicp sicp-pict $collects/

      # Run a full `raco setup` while $out is still writable. This has to cover
      # *every* module, tests included, not just the entry points: anything
      # left uncompiled here is something a later `raco setup` on the installed
      # system would try to compile into the read-only store, and fail on.
      # raco also wants a writable HOME for its info cache.
      export HOME=$TMPDIR
      PLTCOLLECTS=":$collects" raco setup --no-docs --no-launcher \
        -j $NIX_BUILD_CORES -l sicp sicp-pict

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
