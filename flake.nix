{
  description = "Marker PDF to Markdown converter";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, poetry2nix }: {
    packages = {
      x86_64-linux.default = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ poetry2nix.overlays.default ];
        };
      in pkgs.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
      };

      aarch64-darwin.default = let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ poetry2nix.overlays.default ];
        };
      in pkgs.poetry2nix.mkPoetryApplication {
        projectDir = ./.;
      };
    };

    devShells = {
      x86_64-linux.default = let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ poetry2nix.overlays.default ];
        };
      in pkgs.mkShell {
        buildInputs = with pkgs; [
          (pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
          })
          pkgs.libffi
        ];
        shellHook = ''
          export PYTHONPATH="$PWD:$PYTHONPATH"
        '';
      };

      aarch64-darwin.default = let
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          overlays = [ poetry2nix.overlays.default ];
        };
      in pkgs.mkShell {
        buildInputs = with pkgs; [
          (pkgs.poetry2nix.mkPoetryEnv {
            projectDir = ./.;
          })
          pkgs.darwin.apple_sdk.frameworks.CoreFoundation
          pkgs.darwin.apple_sdk.frameworks.Accelerate
          pkgs.libffi
        ];
        shellHook = ''
          export PYTHONPATH="$PWD:$PYTHONPATH"
        '';
      };
    };
  };
}
