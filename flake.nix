{
  description = "VSCode with specific extensions for macOS and Linux on ARM and Intel";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          default = self.packages.${system}.vscode-with-extensions;
          vscode-with-extensions = pkgs.vscode-with-extensions.override {
            vscodeExtensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              ms-python.python
              ms-azuretools.vscode-docker
            ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "remote-ssh";
                publisher = "ms-vscode-remote";
                version = "0.102.0";
                sha256 = "sha256-YQ0Dy1C+xEGtwh0z97ypIMUq8D7PozVRb6xXUVZsjBw=";
              }
            ];
          };
        }
      );
      # Add a devShell for each supported system
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in {
          default = pkgs.mkShell {
            buildInputs = [ self.packages.${system}.vscode-with-extensions ];
          };
        }
      );
    };
}
