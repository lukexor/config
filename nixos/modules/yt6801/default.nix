{ stdenv, linuxHeaders, kernel }:
stdenv.mkDerivation rec {
  name = "yt6801-${version}-module-${kernel.version}";
  version = "1.0.28";

  src = ./src;

  hardeningDisable = ["pic"];

  nativebuildInputs = kernel.moduleBuildDependencies;

  preBuild = ''
    substituteInPlace Makefile --replace-quiet "KSRC_BASE =" "KSRC_BASE ?="
    export C_INCLUDE_PATH="${linuxHeaders}/include/:$C_INCLUDE_PATH"
  '';

  makeFlags = [
    "KSRC_BASE=${kernel.dev}/lib/modules/${kernel.modDirVersion}"
    "INSTALL_MOD_PATH=$(out)"
  ];

  buildFlags = ["modules"];

  meta = {
    description = "This is the Linux device driver released for Motorcomm YT6801 Gigabit Ethernet controllers with PCI-Express interface.";
    homepage = "https://github.com/silent-reader-cn/yt6801";
    maintainers = [];
    platforms = ["x86_64-linux"];
  };
}
