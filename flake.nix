{
  description = "VSCode with specific extensions for macOS (ARM and Intel) and Linux (Intel only)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
      unsupportedSystems = [ "aarch64-linux" ];
      allSystems = supportedSystems ++ unsupportedSystems;

      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f system);

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgsFor.${system};
        in
        {
          default =
            if (builtins.elem system supportedSystems) then
              pkgs.vscode-with-extensions.override {
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
              }
            else
              pkgs.runCommand "dummy-vscode" {} ''
                mkdir -p $out/bin
                echo "echo 'VSCode is not supported on this platform'" > $out/bin/vscode
                chmod +x $out/bin/vscode
              '';
        }
      );

      # Add a devShell for each system
      devShells = forAllSystems (system:
        let 
          pkgs = nixpkgsFor.${system};
        in 
        {
          default = pkgs.mkShell {
            buildInputs = [ self.packages.${system}.default ];
          };
        }
      );
    };
}
