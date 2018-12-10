{ stdenv, fetchgit, python3Packages }:

python3Packages.buildPythonApplication rec {
  name = "iotop-unstable-2018-12-10";

  src = fetchgit {
    url = "https://repo.or.cz/iotop.git";
    rev = "7c51ce0e29bd135c216f18e18f0c4ab769af0d6f";
    sha256 = "188g6p9z5p8apw6s2wi671f327x5mxj5rj6lx17wyq32css70vlh";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    description = "A tool to find out the processes doing the most IO";
    homepage = http://guichaz.free.fr/iotop;
    license = licenses.gpl2;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
