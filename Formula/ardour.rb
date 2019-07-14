class Ardour < Formula
  desc "A digital audio workstation"
  homepage "https://ardour.org/"
  url "https://community.ardour.org/srctar"
  version "5.12"
  sha256 "7e2a679b9a7eca7c72ec2fb9839b3e7d9e0049d83a8f9a1682788b5206fbd526"
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

  patch :DATA

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

__END__
diff --git a/wscript b/wscript
--- a/wscript
+++ b/wscript
@@ -403,6 +403,8 @@ int main() { return 0; }''',
             conf.env['build_host'] = 'sierra'
         elif re.search ("^17[.]", version) != None:
             conf.env['build_host'] = 'high_sierra'
+        elif re.search ("^18[.]", version) != None:
+            conf.env['build_host'] = 'mojave'
         else:
             conf.env['build_host'] = 'irrelevant'
 
@@ -430,8 +432,10 @@ int main() { return 0; }''',
                 conf.env['build_target'] = 'el_capitan'
             elif re.search ("^16[.]", version) != None:
                 conf.env['build_target'] = 'sierra'
-            else:
+            elif re.search ("^17[.]", version) != None:
                 conf.env['build_target'] = 'high_sierra'
+            else:
+                conf.env['build_target'] = 'mojave'
         else:
             match = re.search(
                     "(?P<cpu>i[0-6]86|x86_64|powerpc|ppc|ppc64|arm|s390x?)",
@@ -452,11 +456,11 @@ int main() { return 0; }''',
         #
         compiler_flags.append ('-U__STRICT_ANSI__')
 
-    if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra' ]:
+    if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
        cxx_flags.append('--stdlib=libc++')
        linker_flags.append('--stdlib=libc++')
 
-    if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra' ]:
+    if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         conf.check_cxx(cxxflags=["-std=c++11"])
         cxx_flags.append('-std=c++11')
         if platform == "darwin":
@@ -464,7 +468,7 @@ int main() { return 0; }''',
             # from requiring a full path to requiring just the header name.
             cxx_flags.append('-DCARBON_FLAT_HEADERS')
 
-            if not opt.use_libcpp and not conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra' ]:
+            if not opt.use_libcpp and not conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
                 cxx_flags.append('--stdlib=libstdc++')
                 linker_flags.append('--stdlib=libstdc++')
             # Prevents visibility issues in standard headers
@@ -473,7 +477,7 @@ int main() { return 0; }''',
             cxx_flags.append('-DBOOST_NO_AUTO_PTR')
 
 
-    if (is_clang and platform == "darwin") or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra' ]:
+    if (is_clang and platform == "darwin") or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         # Silence warnings about the non-existing osx clang compiler flags
         # -compatibility_version and -current_version.  These are Waf
         # generated and not needed with clang
@@ -589,7 +593,7 @@ int main() { return 0; }''',
                 ("-DMAC_OS_X_VERSION_MAX_ALLOWED=1090",
                  "-mmacosx-version-min=10.8"))
 
-    elif conf.env['build_target'] in ['el_capitan', 'sierra', 'high_sierra' ]:
+    elif conf.env['build_target'] in ['el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         compiler_flags.extend(
                 ("-DMAC_OS_X_VERSION_MAX_ALLOWED=1090",
                  "-mmacosx-version-min=10.9"))
@@ -965,7 +969,6 @@ def configure(conf):
         #       off processor type.  Need to add in a check
         #       for that.
         #
-        conf.env.append_value('CXXFLAGS_OSX', '-F/System/Library/Frameworks')
         conf.env.append_value('CXXFLAGS_OSX', '-F/Library/Frameworks')
 
         conf.env.append_value('LINKFLAGS_OSX', ['-framework', 'AppKit'])
-- 
2.22.0

