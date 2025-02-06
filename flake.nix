{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        lib = nixpkgs.lib;

        jekyllEnv = pkgs.bundlerEnv {
          name = "gemset";
          gemdir = ./.;
        };
      in
      {
        packages = rec {
          site = pkgs.stdenv.mkDerivation {
            name = "assessor-thesis-site";

            src = ./.;

            buildInputs = [
              jekyllEnv
              pkgs.locale
            ];

            env = {
              LANG = "C.UTF-8";
            };

            buildPhase = ''
              bundle exec jekyll build
            '';

            installPhase = ''
              mkdir -- "$out"
              cp -R -- _site/* "$out"
            '';
          };

          default = site;
        };
      });
}
