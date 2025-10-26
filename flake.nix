{
  description = "";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        packages.default = pkgs.sbcl.buildASDFSystem rec {
          pname = "awesomes";
          version = "0.1";
          src = self;
          lispLibs = with pkgs.sbclPackages; [
            alexandria
            arrow-macros
            serapeum
            defmain
            cl-ppcre
          ];
          nativeLibs = [
            pkgs.openssl
          ];
        };
      }
    );
}
