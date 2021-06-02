{ lib
, stdenv
, fetchFromGitHub
, unstableGitUpdater
, rustPlatform
, cargo
, Security
, libiconv
, withDocs ? true
, sphinx
, withPrefix ? false
, buildMulticallBinary ? true
}:

let
  prefix = "uutils-";
in
stdenv.mkDerivation rec {
  pname = "uutils-coreutils";
  version = "0.0.12";

  src = fetchFromGitHub {
    owner = "uutils";
    repo = "coreutils";
    rev = version;
    name = "${pname}-${version}";
    sha256 = "sha256-N2CuMkhYFKsvshHXDVqe0itYuS+a9njathBjj3N/RGI=";
  };

  postPatch = ''
    # don't enforce the building of the man page
    substituteInPlace GNUmakefile \
      --replace 'install: build' 'install:'
  '';

  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
    name = "${pname}-${version}";
    hash = "sha256-zuJAVxt3mfw5JBjaulyXNK0Q+geItPF7+JKMZhcT3TU=";
  };

  nativeBuildInputs = [ rustPlatform.cargoSetupHook ]
    ++ lib.optional withDocs sphinx;

  buildInputs = lib.optionals stdenv.isDarwin [ Security libiconv ];

  makeFlags = [
    "CARGO=${cargo}/bin/cargo"
    "PREFIX=${placeholder "out"}"
    "PROFILE=release"
    "INSTALLDIR_MAN=${placeholder "out"}/share/man/man1"
  ] ++ lib.optionals withPrefix [ "PROG_PREFIX=${prefix}" ]
  ++ lib.optionals buildMulticallBinary [ "MULTICALL=y" ]
  ++ lib.optionals (!withDocs) [ "build-coreutils" "build-pkgs" ];

  # too many impure/platform-dependent tests
  doCheck = false;

  passthru.updateScript = unstableGitUpdater {
    url = "https://github.com/uutils/coreutils.git";
  };

  meta = with lib; {
    description = "Cross-platform Rust rewrite of the GNU coreutils";
    longDescription = ''
      uutils is an attempt at writing universal (as in cross-platform)
      CLI utils in Rust. This repo is to aggregate the GNU coreutils rewrites.
    '';
    homepage = "https://github.com/uutils/coreutils";
    maintainers = with maintainers; [ siraben SuperSandro2000 ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}
