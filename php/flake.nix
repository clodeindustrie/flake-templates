{
    description = "My flake for php/node projects";

    inputs = {
        nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
        flake-utils = { url = "github:numtide/flake-utils"; };
        phps.url = "github:fossar/nix-phps";
    };

    outputs = { self, nixpkgs, flake-utils, phps }:
        flake-utils.lib.eachDefaultSystem (system:
            let
                pkgs = import nixpkgs { inherit system; };
            in rec {
                  devShell = pkgs.mkShell {
                      buildInputs = [
                          pkgs.just
                          pkgs.nodejs-20_x
                          # pkgs.phpactor
                          phps.packages.${system}.php81
                          phps.packages.${system}.php81.packages.composer
                      ];

                      shellHook = ''
                        if [ ! -f .envrc ]; then
                        echo "use flake" >> .envrc
                        echo "dotenv_if_exists .env" >> .envrc
                        fi
                        export PATH="$PWD/node_modules/.bin/:$PATH"
                      '';
                  };
              });
}
