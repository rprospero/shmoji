{
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.flake-utils.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-linux" "aarch64-linux" ] (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "shmoji";
          src = ./.;
          buildInputs = [ pkgs.wtype pkgs.rofi ];
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin
            cp shmoji $out/bin
            wrapProgram $out/bin/shmoji --prefix PATH : ${
              pkgs.lib.makeBinPath [ pkgs.wtype pkgs.rofi ]
            }
          '';
        };
      });
}
