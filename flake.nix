{
  description = "VSCode with specific extensions for macOS (ARM and Intel) and Linux (Intel only)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      allSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs allSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          
          supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-darwin" ];
          
          vscodePackage = 
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
            else null;
        in
        {
          default = vscodePackage;
        }
      );

      # Add a devShell for each system
      devShells = forAllSystems (system:
        let 
          pkgs = nixpkgs.legacyPackages.${system};
          vscodePackage = self.packages.${system}.default;
        in 
        {
          default = pkgs.mkShell {
            buildInputs = if vscodePackage != null then [ vscodePackage ] else [];
          };
        }
      );
    };
}
