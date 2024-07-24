{
  description = "VSCode with a very specific set of extensions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            system = system;
            config.allowUnfree = true;
          };
          vscodeExtensions = [
            pkgs.vscode-extensions.bbenoist.nix
            pkgs.vscode-extensions.ms-python.python
            pkgs.vscode-extensions.ms-azuretools.vscode-docker
          ];
          vscodeWithExtensions = pkgs.vscode-with-extensions.override {
            inherit vscodeExtensions;
          };
        in
        {
          default = vscodeWithExtensions;
        }
      );
    };
}
