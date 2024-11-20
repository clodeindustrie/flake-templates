{
  description = "My flake for php/node projects";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    phps.url = "github:fossar/nix-phps";
  };

  outputs = { self, nixpkgs, flake-utils, phps, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        nativeBuildInputs = with pkgs; [
          pkgs.just
          pkgs.nodejs-20_x
          phps.packages.${system}.php81
          phps.packages.${system}.php81.packages.composer
        ];
        buildInputs = with pkgs; [];
      in rec {

        devShells.default = pkgs.mkShell {
          inherit nativeBuildInputs buildInputs;

          shellHook = ''
            export PATH="$PWD/node_modules/.bin/:$PATH"
            '';
        };
      });
}
