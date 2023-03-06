{
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
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
      }) // {
        homeManagerModule.default = { config, pkgs, ... }: {
          wayland.windowManager.sway.config.keybindings."Mod4+o" =
            "exec ${self.packages.x86_64-linux.default}/bin/shmoji rofi-wayland";
        };
      };
}
