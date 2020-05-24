class Ardour < Formula
  desc "A digital audio workstation"
  homepage "https://ardour.org/"
  url "https://community.ardour.org/srctar"
  version "6.0"
  sha256 "ee74e3644b56e171c022f048d9a964c673063641892b97e96180fec83e6d0bf4"
  head "https://github.com/Ardour/ardour.git"

  depends_on "aubio"
  depends_on "boost"
  depends_on "fftw"
  depends_on "glib"
  depends_on "glibmm"
  depends_on "jack"
  depends_on "libarchive"
  depends_on "liblo"
  depends_on "libsndfile"
  depends_on "libusb"
  depends_on "lrdf"
  depends_on "lv2"
  depends_on "pangomm"
  depends_on "pkg-config" => :build
  depends_on "rubberband"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"
  depends_on "gtkmm"
  depends_on "lilv"
  depends_on "taglib"
  depends_on "vamp-plugin-sdk"

  def install
    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=jack"
    system "./waf", "install"

    cd "./tools/osx_packaging" do
      system "./osx_build", "--help"
    end
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ardour`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
