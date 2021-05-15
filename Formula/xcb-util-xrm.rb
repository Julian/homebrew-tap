class XcbUtilXrm < Formula
  desc "XCB utility functions for the X resource manager "
  homepage "https://github.com/Airblader/xcb-util-xrm"
  url "https://github.com/Airblader/xcb-util-xrm/releases/download/v1.3/xcb-util-xrm-1.3.tar.gz"
  sha256 "0129f74c327ae65e2f4ad4002f300b4f02c9aff78c00997f1f1c5a430f922f34"

  depends_on "pkg-config" => :build

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
