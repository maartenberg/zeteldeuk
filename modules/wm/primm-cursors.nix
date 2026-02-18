{
  fetchzip,
  p7zip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "primm-cursors";
  version = "2024-05-08";

  src = fetchzip {
    url = "https://files.primm.gay/extras/cursors/Wii/Linux%20Cursors.7z";
    nativeBuildInputs = [p7zip];
    sha256 = "sha256-Rs6u5FfyRISkmltaTxgyPlEq+WQfZy7s0940TIK3rUQ=";
  };

  buildPhase = "true";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    for player in 1 2 3 4; do
      cp --verbose --archive $src/Wii-Pointer-P$player $out/share/icons
    done

    runHook postInstall
  '';
}
