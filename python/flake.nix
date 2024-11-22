{
  description = "My python project flake";

  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixpkgs-unstable"; };
    flake-utils = { url = "github:numtide/flake-utils"; };
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        inherit (nixpkgs.lib) optional;

        my-python = pkgs.python3;
        python-with-my-packages = my-python.withPackages (p: with p; [
          pip
          black
          isort
        ]);

        nativeBuildInputs = with pkgs; [
          pkgs.just
          pkgs.html-tidy
          python-with-my-packages
        ];
        buildInputs = with pkgs; [];
      in rec
        {
          devShells.default = pkgs.mkShell {
            inherit nativeBuildInputs buildInputs;

            shellHook = ''
                export PYTHONPATH=${python-with-my-packages}/${python-with-my-packages.sitePackages}
                # maybe set more env-vars
                export PATH="$PWD/node_modules/.bin/:$PYTHONPATH:$PATH"
                # python3 -m venv venv
                # source venv/bin/activate
                # pip install -r requirements.txt
            '';
          };
        });
}
