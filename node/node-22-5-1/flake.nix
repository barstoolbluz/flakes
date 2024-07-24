{
  description = "Flake for Node.js v22.5.1";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          nodejsFor = {
            x86_64-linux = {
              url = "https://nodejs.org/dist/v22.5.1/node-v22.5.1-linux-x64.tar.gz";
              sha256 = "sha256-KnuLiqXHOa5VIz1Z94c2kRqKXaXqHGPw6EPaJw0DlJk=";
            };
            x86_64-darwin = {
              url = "https://nodejs.org/dist/v22.5.1/node-v22.5.1-darwin-x64.tar.gz";
              sha256 = "sha256-astFM7wKQ6Ro+Qu9SSMKoWx8V7KjRR7+Ahdf7qNGdU0=";
            };
            aarch64-darwin = {
              url = "https://nodejs.org/dist/v22.5.1/node-v22.5.1-darwin-arm64.tar.gz";
              sha256 = "sha256-dgI4SFXx4Wm2DlHDYOWixnK4mhnM2gGZzkZ11o/vqvI=";
            };
            aarch64-linux = {
              url = "https://nodejs.org/dist/v22.5.1/node-v22.5.1-linux-arm64.tar.gz";
              sha256 = "sha256-jfr0ss48Y5dx9r5wAbrIHs4O6jzWZoZmwAEAvxdaFO4=";
            };
          };
          nodejs = pkgs.stdenv.mkDerivation {
            pname = "nodejs";
            version = "22.5.1";
            src = pkgs.fetchurl (nodejsFor.${system});
            buildInputs = [ pkgs.stdenv ];
            installPhase = ''
              mkdir -p $out
              cp -r * $out/
            '';
          };
        in
        {
          default = nodejs;
        }
      );
    };
}
