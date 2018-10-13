class Ardour < Formula
  desc "A digital audio workstation"
  homepage "https://ardour.org/"
  url "https://community.ardour.org/srctar"
  version "5.12"
  sha256 "7e2a679b9a7eca7c72ec2fb9839b3e7d9e0049d83a8f9a1682788b5206fbd526"

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
    system "./waf", "configure", "--prefix=#{prefix}", "--with-backends=coreaudio,jack"
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
--- a/wscript     2018-10-13 16:17:12.000000000 -0400
+++ b/wscript       2018-10-13 16:17:32.000000000 -0400
@@ -384,6 +384,10 @@
             conf.env['build_host'] = 'el_capitan'
         elif re.search ("^16[.]", version) != None:
             conf.env['build_host'] = 'sierra'
+        elif re.search ("^17[.]", version) != None:
+            conf.env['build_host'] = 'high_sierra'
+        elif re.search ("^18[.]", version) != None:
+            conf.env['build_host'] = 'mojave'
         else:
             conf.env['build_host'] = 'irrelevant'
 
@@ -409,8 +413,12 @@
                 conf.env['build_target'] = 'yosemite'
             elif re.search ("^15[.]", version) != None:
                 conf.env['build_target'] = 'el_capitan'
-            else:
+            elif re.search ("^16[.]", version) != None:
                 conf.env['build_target'] = 'sierra'
+            elif re.search ("^17[.]", version) != None:
+                conf.env['build_target'] = 'high_sierra'
+            else:
+                conf.env['build_target'] = 'mojave'
         else:
             match = re.search(
                     "(?P<cpu>i[0-6]86|x86_64|powerpc|ppc|ppc64|arm|s390x?)",
@@ -431,11 +439,11 @@
         #
         compiler_flags.append ('-U__STRICT_ANSI__')
 
-    if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan', 'sierra' ]:
+    if opt.use_libcpp or conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
        cxx_flags.append('--stdlib=libc++')
        linker_flags.append('--stdlib=libc++')
 
-    if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra' ]:
+    if conf.options.cxx11 or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         conf.check_cxx(cxxflags=["-std=c++11"])
         cxx_flags.append('-std=c++11')
         if platform == "darwin":
@@ -443,7 +451,7 @@
             # from requiring a full path to requiring just the header name.
             cxx_flags.append('-DCARBON_FLAT_HEADERS')
 
-            if not opt.use_libcpp and not conf.env['build_host'] in [ 'el_capitan', 'sierra' ]:
+            if not opt.use_libcpp and not conf.env['build_host'] in [ 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
                 cxx_flags.append('--stdlib=libstdc++')
                 linker_flags.append('--stdlib=libstdc++')
             # Prevents visibility issues in standard headers
@@ -452,7 +460,7 @@
             cxx_flags.append('-DBOOST_NO_AUTO_PTR')
 
 
-    if (is_clang and platform == "darwin") or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra' ]:
+    if (is_clang and platform == "darwin") or conf.env['build_host'] in [ 'mavericks', 'yosemite', 'el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         # Silence warnings about the non-existing osx clang compiler flags
         # -compatibility_version and -current_version.  These are Waf
         # generated and not needed with clang
@@ -568,7 +576,7 @@
                 ("-DMAC_OS_X_VERSION_MAX_ALLOWED=1090",
                  "-mmacosx-version-min=10.8"))
 
-    elif conf.env['build_target'] in ['el_capitan', 'sierra' ]:
+    elif conf.env['build_target'] in ['el_capitan', 'sierra', 'high_sierra', 'mojave' ]:
         compiler_flags.extend(
                 ("-DMAC_OS_X_VERSION_MAX_ALLOWED=1090",
                  "-mmacosx-version-min=10.9"))
--- a/libs/backends/coreaudio/wscript     2018-10-13 16:38:33.000000000 -0400
+++ b/libs/backends/coreaudio/wscript      2018-10-13 16:37:55.000000000 -0400
@@ -31,7 +31,7 @@
     obj.use      = 'libardour libpbd'
     obj.uselib   = 'GLIBMM XML'
     obj.framework = [ 'CoreAudio', 'AudioToolbox', 'CoreServices' ]
-    if bld.env['build_target'] not in [ 'lion', 'el_capitan' ] and (not bld.env['build_arch'] == "ppc"):
+    if bld.env['build_target'] not in [ 'lion', 'el_capitan', 'sierra', 'high_sierra', 'mojave' ] and (not bld.env['build_arch'] == "ppc"):
         obj.framework += [ 'CoreMidi' ]
     else:
         obj.framework += [ 'CoreMIDI' ]
