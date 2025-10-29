{
  description = "";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in rec {
        packages.default = pkgs.sbcl.buildASDFSystem {
          pname = "awesomes";
          version = "0.1";
          src = self;
          lispLibs = with pkgs.sbclPackages; [
            alexandria
            serapeum
            cl-ppcre
            hunchentoot
            spinneret
            dexador
            com_dot_inuoe_dot_jzon
            lparallel
            log4cl
            trivia
            local-time
          ];
          buildScript = pkgs.writeText "build-awesomes" ''
            (require 'asdf)
            (asdf:load-system "awesomes")
            (sb-ext:save-lisp-and-die
                        "awesomes"
                        :executable t
                        #+sb-core-compression :compression
                        #+sb-core-compression t
                        :toplevel #'generate:generate)
          '';
          nativeBuildInputs = [
            pkgs.makeWrapper
          ];

          installPhase =   ''
            runHook preInstall
            mkdir -p $out/bin
            cp awesomes $out/bin
            wrapProgram $out/bin/awesomes \
                        --prefix LD_LIBRARY_PATH : $LD_LIBRARY_PATH
            runHook postInstall
          '';
        };
      }
    );
}
