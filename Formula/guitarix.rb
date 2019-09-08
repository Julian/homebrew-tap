class Guitarix < Formula
  desc "virtual versatile amplification for Jack/*nix"
  homepage "https://guitarix.org"
  url "https://downloads.sourceforge.net/project/guitarix/guitarix/guitarix2-0.38.1.tar.xz"
  sha256 "00fda3e1ce1d5f1691665f9ff32bb3c9800381313d49b7c2e25618d0b3ed872f"

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "libffi"
  depends_on "libsndfile"
  depends_on "zita-convolver"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
