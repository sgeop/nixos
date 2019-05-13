{ stdenv, fetchzip, makeWrapper }:

stdenv.mkDerivation {
  name = "gradle-5.4.1";
  src = fetchzip {
    url = "https://services.gradle.org/distributions/gradle-5.4.1-bin.zip";
    sha256 = "1nrlmqzgjzg1a0h8g3256z12zr981kf4m2gn1ynbhi7j2qrk9f2k";
  };

  buildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/opt/gradle
    cp -r $src/* $out/opt/gradle
    makeWrapper "$out/opt/gradle/bin/gradle" "$out/bin/gradle"
  '';
}
