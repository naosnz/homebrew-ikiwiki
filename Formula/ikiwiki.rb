# ikiwiki HomeBrew formula
#
# Written by Ewen McNeill <ewen@naos.co.nz>, 2024-02-05
# Updated by Ewen McNeill <ewen@naos.co.nz>, 2024-02-05
#
# Inspired by the rejected homebrew ikiwiki formula (~2011):
#
# https://github.com/Homebrew/legacy-homebrew/pull/5355/files
# https://ikiwiki.info/forum/Can_someone_add_Ikiwiki_in_Homebrew__63__/
#
# and the Macports packaging of ikiwiki:
#
# https://github.com/macports/macports-ports/blob/master/www/ikiwiki/Portfile
#
# and Debian packaging:
#
# https://packages.debian.org/sid/ikiwiki
#
# See also:
#
# https://ikiwiki.info/tips/ikiwiki_on_mac_os_x/
#
# for manual build instructions which covers more of the optional dependencies.
#
# Packages from the Debian repository package as that seems like the
# commonly agreed archive download site (ie, non-git repo), including
# recommended at https://ikiwiki.info/download/
#
# Only the Perl modules identified as Debian as required dependencies, and
# those that ikiwiki's installer insists must be present are currently
# currently installed, to get the base Ikiwiki running.  There are *many*
# optional dependencies, mostly for optional extension features of ikiwki.
#
# For simplicity of the install, the "shipped with macOS" version of
# Perl is used, and the Perl modules shipped with macOS are assumed to
# already be present.  (This has not been tested on Linux.)
#
# Check for "shipped with macOS" perl modules with:
#
# /usr/bin/perl -M${MODULE} -e1
# find $(/usr/bin/perl -le 'print join("\n", @INC);') -type f 2>&1 | grep ...
#
#---------------------------------------------------------------------------
# Required Dependencies (identified by Debian):
#
# HTML::Parser (libhtml-parser-perl):
# -- shiped with macOS in /System/Library/Perl/Extras
#
# HTML::Scrubber (libhtml-scrubber-perl):
# -- CPAN: https://metacpan.org/pod/HTML::Scrubber
#
# HTML::Template (libhtml-template-perl):
# -- CPAN: https://metacpan.org/pod/HTML::Template       
#
# JSON (libjson-perl)
# -- shipped with maCOS in /System/Library/Perl/Extras
#
# Markdown (libmarkdown2 -- https://packages.debian.org/sid/libmarkdown2)
# -- C library, "Discount is an implementation of John Gruber's Markdown
#    markup language"
# -- Provided by Homebrew "discount" package
#
# Text::Markdown::Discount (libtext-markdown-discount-perl)
# -- CPAN: https://metacpan.org/pod/Text::Markdown::Discount
#
# URI (liburi-perl)
# -- shiped with macOS in /System/Library/Perl/Extras
#
# YAML (Perl: libyaml-libyaml-perlML which is now called YAML::XS)
# -- macOS has YAML::PP (https://metacpan.org/pod/YAML::PP), but different API
# -- CPAN: https://metacpan.org/pod/YAML::XS
# 
#---------------------------------------------------------------------------
#
# ikiwiki warnings about dependencies:
#
# Warning: prerequisite CGI::FormBuilder v3.2.2 not found.
# Warning: prerequisite CGI::Session 0 not found.
# Warning: prerequisite Mail::Sendmail 0 not found.
# Warning: prerequisite Text::Markdown 0 not found.
#
# Other TODO:
#
# ikiwiki-mass-rebuild  uses config file /etc/ikiwiki/wikilist
#                       (should be /usr/local/etc/ikiwiki/wikilist)
#
#---------------------------------------------------------------------------
# See Debian and MacPorts packaging for potential optional dependencies.
#---------------------------------------------------------------------------
# 
class Ikiwiki < Formula
  desc "The ikiwiki wiki compiler (written in perl)"
  homepage "https://ikiwiki.info/"
  url "http://ftp.debian.org/debian/pool/main/i/ikiwiki/ikiwiki_3.20200202.3.orig.tar.xz"
  sha256 "594f13bcee8959356376a42eed6c5a8e295d325724b1c09f9395404e3262796a"
  license "GPL-2+"

  uses_from_macos "perl"
  depends_on "discount"     # Markdown Parser
  depends_on "gettext"      # Translations

  resource "HTML::Scrubber" do
    url    "https://cpan.metacpan.org/authors/id/N/NI/NIGELM/HTML-Scrubber-0.19.tar.gz"
    sha256 "ae285578f8565f9154c63e4234704b57b6835f77a2f82ffe724899d453262bb1"
  end

  resource "HTML::Template" do
    url    "https://cpan.metacpan.org/authors/id/S/SA/SAMTREGAR/HTML-Template-2.97.tar.gz"
    sha256 "6547af61f3aa85793f8616190938d677d7995fb3b720c16258040bc935e2129f"
  end

  resource "Text::Markdown::Discount" do
    url    "https://cpan.metacpan.org/authors/id/S/SE/SEKIMURA/Text-Markdown-Discount-0.16.tar.gz"
    sha256 "adcbc9d3f986d1344648cba6476634eb8621c773941f7f3d10860f96d8089233"
  end

  resource "YAML::XS" do
    url    "https://cpan.metacpan.org/authors/id/T/TI/TINITA/YAML-LibYAML-0.89.tar.gz"
    sha256 "155ab83675345c50add03311acf9dd915955707f909a2abd8b17d7792859b2ec"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("HTML::Scrubber").stage do
      ohai "Installing resource HTML::Scrubber"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("HTML::Template").stage do
      ohai "Installing resource HTML::Template"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("Text::Markdown::Discount").stage do
      ohai "Installing resource Text::Markdown::Discount"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("YAML::XS").stage do
      ohai "Installing resource YAML::XS"
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    # Build ikiwiki with the Debian specific overrides
    ohai "Installing main ikiwiki application (with Discount Markdown parser)"
    ENV["IKIWIKI_TEST_ASSUME_MODERN_DISCOUNT"] = "1"
    ENV["LC_ALL"]                              = "C"         # Debian: C.UTF-8
    ENV["TZ"]                                  = "UTC"

    # We need to ensure the xgettext / msgfmt binaries are on the PATH
    ENV.prepend_path "PATH", Formula["gettext"].bin

    system "mkdir", "#{libexec}/bin"
    system "perl", "Makefile.PL", "PREFIX=#{prefix}",
                   "INSTALLBINDIR=#{libexec}/bin",
                   "INSTALLSITEMAN1DIR=#{man1}", "INSTALLSITEMAN3DIR=#{man3}"
    system "make"
    system "make", "install"
    bin.env_script_all_files libexec/"bin", PERL5LIB: "#{lib}/perl5:#{libexec}/lib/perl5"

    # Install example configuration files into etc subdirectory
    system "mkdir", "-p", "#{etc}/ikiwiki"
    etc.install "auto.setup"      => "ikiwiki/auto.setup"
    etc.install "auto-blog.setup" => "ikiwiki/auto-blog.setup"
    etc.install "wikilist"        => "ikiwiki/wikilist"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! For Homebrew/homebrew-core
    # this will need to be a test that verifies the functionality of the
    # software. Run the test with `brew test ikiwiki`. Options passed
    # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    #
    # Trivial check that ikiwiki can at least be parsed
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    system "perl", "-c", "#{bin}/ikiwiki"
  end
end
