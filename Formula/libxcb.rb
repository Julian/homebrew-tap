class Libxcb < Formula
  desc "Interface to the X Window System protocol and replacement for Xlib"
  homepage "https://www.x.org/"
  url "https://xcb.freedesktop.org/dist/libxcb-1.13.1.tar.bz2"
  sha256 "a89fb7af7a11f43d2ce84a844a4b38df688c092bf4b67683aef179cdf2a647c4"

  depends_on "pkg-config" => :build
  depends_on "xcb-proto" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
