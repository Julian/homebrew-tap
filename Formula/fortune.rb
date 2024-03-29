class Fortune < Formula
  desc "Infamous electronic fortune-cookie generator"
  homepage "https://www.ibiblio.org/pub/linux/games/amusements/fortune/!INDEX.html"
  url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/fortune-mod-9708.tar.gz"
  mirror "https://src.fedoraproject.org/repo/pkgs/fortune-mod/fortune-mod-9708.tar.gz/81a87a44f9d94b0809dfc2b7b140a379/fortune-mod-9708.tar.gz"
  sha256 "1a98a6fd42ef23c8aec9e4a368afb40b6b0ddfb67b5b383ad82a7b78d8e0602a"
  license "BSD-4-Clause-UC"

  livecheck do
    url "https://www.ibiblio.org/pub/linux/games/amusements/fortune/"
    regex(/href=.*?fortune-mod[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end


  patch :DATA

  def install
    ENV.deparallelize

    inreplace "Makefile" do |s|
      # Use our selected compiler
      s.change_make_var! "CC", ENV.cc

      # Change these first two folders to the correct location in /usr/local...
      s.change_make_var! "FORTDIR", "/usr/local/bin"
      s.gsub! "/usr/local/man", "/usr/local/share/man"
      # Now change all /usr/local at once to the prefix
      s.gsub! "/usr/local", prefix

      # macOS only supports POSIX regexes
      s.change_make_var! "REGEXDEFS", "-DHAVE_REGEX_H -DPOSIX_REGEX"
    end

    system "make", "install"
  end

  test do
    system "#{bin}/fortune"
  end
end

__END__
--- a/util/rot.c
+++ b/util/rot.c
@@ -5,6 +5,7 @@
 
 #include <stdio.h>
 #include <ctype.h>
+#include <stdlib.h>
 
 int main(void)
 {
--- a/util/unstr.c
+++ b/util/unstr.c
@@ -96,6 +96,7 @@ static char sccsid[] = "@(#)unstr.c	8.1 (Berkeley) 5/31/93";
 #include	<ctype.h>
 #include	<string.h>
 #include	<unistd.h>
+#include	<stdlib.h>
 
 #ifndef MAXPATHLEN
 #define	MAXPATHLEN	1024
