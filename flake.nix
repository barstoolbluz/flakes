{
  description = "VSCode with a very specific set of extensions";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages.x86_64-linux = let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-linux";
      };
    in
    {
      default = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
        ];
      };
    };

    packages.x86_64-darwin = let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "x86_64-darwin";
      };
    in
    {
      default = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
        ];
      };
    };

    packages.aarch64-darwin = let
      pkgs = import nixpkgs {
        config.allowUnfree = true;
        system = "aarch64-darwin";
      };
    in
    {
      default = pkgs.vscode-with-extensions.override {
        vscodeExtensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          ms-python.python
          ms-azuretools.vscode-docker
        ];
      };
    };
  };
}
