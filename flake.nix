{
  description = "VSCode with a very specific set of extensions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    {
      packages = builtins.mapAttrs (
        system: pkgs:
        let
          pkgs = import nixpkgs {
            config.allowUnfree = true;
            inherit system;
          };
        in
        rec {
          default = vscode-with-extensions;
          vscode-with-extensions = pkgs.vscode-with-extensions.override {
            vscodeExtensions = with pkgs.vscode-extensions; [
              bbenoist.nix
              ms-python.python
              ms-azuretools.vscode-docker
            ];
          };
        }
      ) nixpkgs.legacyPackages;
    };
}
