{ stdenv, fetchFromGitHub, makeWrapper
, cmake, llvmPackages, rapidjson }:

let
  src = fetchFromGitHub {
    owner = "MaskRay";
    repo = "ccls";
    rev = "0.20181225";
    sha256 = "1zbph6pmlva43d3a405xl75bxxp5ic3p6fbaqinvm5clmfn93mr7";
  };
in
stdenv.mkDerivation rec {
  name    = "ccls-${version}";
  version = "2018-10-14";

  inherit src;

  nativeBuildInputs = [ cmake makeWrapper ];
  buildInputs = with llvmPackages; [ clang-unwrapped llvm rapidjson ];

  cmakeFlags = [ "-DSYSTEM_CLANG=ON" ];

  shell = stdenv.shell;
  postFixup = ''
    # We need to tell ccls where to find the standard library headers.

    standard_library_includes="\\\"-isystem\\\", \\\"${stdenv.lib.getDev stdenv.cc.libc}/include\\\""
    standard_library_includes+=", \\\"-isystem\\\", \\\"${llvmPackages.libcxx}/include/c++/v1\\\""
    export standard_library_includes

    wrapped=".ccls-wrapped"
    export wrapped

    mv $out/bin/ccls $out/bin/$wrapped
    substituteAll ${./wrapper} $out/bin/ccls
    chmod --reference=$out/bin/$wrapped $out/bin/ccls
  '';

  meta = with stdenv.lib; {
    description = "A c/c++ language server powered by libclang";
    homepage    = https://github.com/MaskRay/ccls;
    license     = licenses.mit;
    platforms   = platforms.linux;
    maintainers = [ maintainers.mic92 ];
  };
}
