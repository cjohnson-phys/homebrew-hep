class Yoda < Formula
  desc "Yet more Objects for Data Analysis"
  homepage "https://yoda.hepforge.org"
  url "https://www.hepforge.org/archive/yoda/YODA-1.7.0.tar.gz"
  sha256 "182e8848986b08764c15a9ef1bd29e4f6e84375e97be8dc948cda5ab9d34b85f"

  bottle do
    root_url "https://dl.bintray.com/davidchall/bottles-hep"
    cellar :any
    sha256 "943992b7196311683bef4f3e9f9c96490de5da4a1ad98b9618e98c0c34b7adf1" => :high_sierra
    sha256 "b533ca5a8dec8eb39414c1a4d657a99a23679e236c8d4ac3735e56b39cec4aca" => :sierra
    sha256 "d283f08feb0bec71556900a3de13dc4b7abca06c6a7c3bc9053830d266de3d62" => :el_capitan
    sha256 "fb8667b0ceac647cfc51d65d3933efec98bff385214b4139237fbefa0fecc95e" => :yosemite
  end

  head do
    url "http://yoda.hepforge.org/hg/yoda", :using => :hg

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "cython" => :build
  end

  option "with-test", "Test during installation"

  depends_on "root" => :optional
  depends_on "numpy" => :optional
  depends_on "homebrew/science/matplotlib" => :optional

  needs :cxx11

  def install
    ENV.cxx11

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.with? "root"
      args << "--enable-root"
      ENV.append "PYTHONPATH", Formula["root"].opt_prefix/"lib/root" if build.with? "test"
    end

    system "autoreconf", "-i" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check" if build.with? "test"
    system "make", "install"

    bash_completion.install share/"YODA/yoda-completion"
  end

  test do
    system bin/"yoda-config", "--version"
    system "python", "-c", "import yoda; yoda.version()"
  end
end
