{
  fetchzip,
  p7zip,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "primm-cursors";
  version = "2025-09-13";

  src = fetchzip {
    url = "https://files.primm.gay/extras/cursors/Wii/Linux%20Cursors%20Scalabler.7z";
    nativeBuildInputs = [p7zip];
    sha256 = "sha256-EDzW/z8TuUuSNvkS4tmkKHx3eIsX22bl+flO0VvoFFE=";
    stripRoot = false;
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
