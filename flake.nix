{
  description = "Example Python development environment for Zero to Nix";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/*.tar.gz";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable}:
    let
      allSystems = [
        "x86_64-linux" # 64-bit Intel/AMD Linux
        "aarch64-linux" # 64-bit ARM Linux
        "x86_64-darwin" # 64-bit Intel macOS
        "aarch64-darwin" # 64-bit ARM macOS
      ];

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs { inherit system; };
        pkgs-unstable = import nixpkgs-unstable { inherit system; };
      });
    in
    {
      devShells = forAllSystems ({ pkgs, pkgs-unstable}: {
        default =
          let
            # Use Python 3.13
            python = pkgs.python313;
          in
          pkgs.mkShell {
            LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib.outPath}/lib:${pkgs.lib.makeLibraryPath [pkgs.zlib]}:$LD_LIBRARY_PATH";
            packages = with pkgs; [
                just
                (python.withPackages (ps: with ps; [
                    pip
                    # LSP 
                    python-lsp-server
                    python-lsp-ruff
                    pylsp-rope
                    ruff
              ]))
            ] ++ [
                pkgs-unstable.uv
            ];
          };
      });
    };
}
