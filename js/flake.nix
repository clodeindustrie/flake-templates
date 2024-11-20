{
  description = "My js project flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (nixpkgs.lib) optional;
        nativeBuildInputs = with pkgs; [
          pkgs.nodejs_20
          pkgs.nodePackages.prettier
          pkgs.bashInteractive
        ];
        buildInputs = with pkgs; [];
      in rec
        {
          devShells.default = pkgs.mkShell {
            inherit nativeBuildInputs buildInputs;

            shellHook = ''
                export PATH="$PWD/node_modules/.bin/:$PATH"
            '';
          };
        });
}
