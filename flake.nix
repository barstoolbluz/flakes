{
  description = "VSCode with a very specific set of extensions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
    in
    {
      packages = builtins.genAttrs systems (system:
        let
          pkgs = import nixpkgs {
            system = system;
            config.allowUnfree = true;
          };
        in
        {
          defaultPackage = pkgs.vscode-with-extensions.override {
            vscodeExtensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              ms-python.python
              ms-azuretools.vscode-docker
            ];
          };
        }
      );

      defaultPackage = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
        ];
      };
    };
}
