{
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default =
          nixpkgs.legacyPackages.x85_64-linux.stdenv.mkDerivation {
            name = "shmoji";
          };
      });
}
