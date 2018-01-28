class Vincia < Formula
  desc "Dipole-antenna shower plugin for Pythia8"
  homepage "https://vincia.hepforge.org"
  url "https://www.hepforge.org/archive/vincia/vincia-2.2.02.tgz"
  sha256 "4c93014cdb3813e10e36d8df494bda75366b81c6a985c729dd15e5089762ec20"

  depends_on "pythia"
  depends_on "wget" => :build
  depends_on "gcc" # for gfortran

  def install
    args = %W[
      --prefix=#{prefix}
      --enable-shared
      --with-pythia8=#{Formula["pythia"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"

    (share/"Vincia/examples").install Dir["examples/*"]
  end

  test do
    ENV["PYTHIA8DATA"] = Formula["pythia"].share/"Pythia8/xmldoc"
    ENV["VINCIADATA"] = share/"Vincia/xmldoc"

    cp_r share/"Vincia/examples/.", testpath
    system "make", "vincia01"
    system "./vincia01"
  end
end
