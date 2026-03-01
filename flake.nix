{
  description = "Marker - PDF/document to markdown converter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in {
      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          python = pkgs.python312;
        in {
          default = pkgs.mkShell {
            buildInputs = [
              python
              pkgs.poetry
              pkgs.libffi
              pkgs.zlib
            ] ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [
              pkgs.apple-sdk
            ];

            shellHook = ''
              export PYTHONPATH="$PWD:$PYTHONPATH"
              # Let poetry manage its own venv inside the project
              export POETRY_VIRTUALENVS_IN_PROJECT=true
              echo "Marker dev shell ready. Run 'poetry install' to set up Python deps."
            '';
          };
        });
    };
}
