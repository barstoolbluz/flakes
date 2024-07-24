{
  description = "VSCode for specific platforms";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: {
    packages = {
      x86_64-linux = let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          system = "x86_64-linux";
        };
      in
      {
        default = pkgs.vscode;
      };

      x86_64-darwin = let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          system = "x86_64-darwin";
        };
      in
      {
        default = pkgs.vscode;
      };

      aarch64-darwin = let
        pkgs = import nixpkgs {
          config.allowUnfree = true;
          system = "aarch64-darwin";
        };
      in
      {
        default = pkgs.vscode;
      };
    };
  };
}
