{
  description = "Rhythm-based aim game";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs, ... }: 
    let
      pkgs = import nixpkgs {
        inherit system;
      };

      system = "x86_64-linux";
    in
    {
      packages.${system}.sound-space-plus = pkgs.stdenv.mkDerivation rec {
        pname = "SoundSpacePlus";
        version = "latest";

        src = pkgs.fetchurl {
          url = "https://github.com/David20122/sound-space-plus/releases/latest/download/linux.zip";
          sha256 = "sha256-MukDJudpv5f9mMY2UWMgDP3HzFZ25Gy5LFC6ZG5bYRg=";
        };

        nativeBuildInputs = [ pkgs.unzip ];

        buildInputs = [
          pkgs.xorg.libX11
          pkgs.xorg.libXcursor
          pkgs.xorg.libXi
          pkgs.xorg.libXinerama
          pkgs.xorg.libXrandr
          pkgs.xorg.libXrender
          pkgs.xorg_sys_opengl
        ];

        unpackPhase = ''
          mkdir -p $out
          unzip $src -d $out
        '';


        installPhase = ''
          mkdir -p $out/bin
          mv $out/SoundSpacePlus.x86_64 $out/bin/SoundSpacePlus
          chmod +x $out/bin/SoundSpacePlus
          mv $out/*.so $out/bin
          mv $out/*.pck $out/bin
          mkdir -p $out/share/applications
          cat > $out/share/applications/soundspaceplus.desktop <<EOF
[Desktop Entry]
Name=SoundSpacePlus
Exec=$out/bin/SoundSpacePlus
Type=Application
EOF
        '';


        meta = with pkgs.lib; {
          description = "Rhythm-based aim game";
          homepage = "https://github.com/David20122/sound-space-plus";
          platforms = ["x86_64-linux"];
        };
      };
    };
}
