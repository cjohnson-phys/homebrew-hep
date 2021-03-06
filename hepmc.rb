require 'formula'

class Hepmc < Formula
  homepage 'http://lcgapp.cern.ch/project/simu/HepMC/'
  url 'http://lcgapp.cern.ch/project/simu/HepMC/download/HepMC-2.06.09.tar.gz'
  sha1 'ecb97190abedfe774629a1cbc961910b4d83b7d6'

  depends_on 'cmake' => :build
  option 'with-check', 'Test during installation'

  def install
    mkdir '../build' do
      system "cmake", buildpath, "-Dmomentum:STRING=GEV", "-Dlength:STRING=MM", *std_cmake_args
      system "make"
      system "make", "test" if build.with? 'check'
      system "make", "install"
    end
  end

  test do
    system "make -C #{share}/HepMC/examples/ example_BuildEventFromScratch.exe"
    system "#{share}/HepMC/examples/example_BuildEventFromScratch.exe"
  end
end
