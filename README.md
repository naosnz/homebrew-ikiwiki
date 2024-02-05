# Homebrew packaging for ikiwiki

[ikiwiki](https://ikiwiki.info/) is a Markdown wiki compiler,
written in Perl.  It has a core plus many extension modules.

It was originally developed by [Joey Hess](http://kitenet.net/~joey/).


## Installation from Homebrew

A basic install of the `ikiwiki` tool (with minimal modules
enabled) can be installed with:

`brew install naosnz/ikiwiki/ikiwiki`

Or as two separate steps:

`brew tap naosnz/ikiwiki`
`brew install ikiwiki`.


## Documentation

The [ikiwiki setup guide](https://ikiwiki.info/setup/) is
a good place to start for learning how to use ikiwiki.  Note that
the `auto.setup`, `auto-blog.setup`, and `wikilist` file are installed
into the Homebrew `etc` directory (eg, `/usr/local/etc/ikiwiki/auto.setup`)
so the example automated setup would be something like:

`ikiwiki --setup /usr/local/etc/ikiwiki/auto.setup`

Alternatively [set up the Wiki by hand](https://ikiwiki.info/setup/byhand/)
which gives much more control over which steps are done.


## Licensing

ikiwiki is available under a [GPLv2+
license](https://ikiwiki.info/freesoftware/).  This Homebrew Formula
to facilitate installing it is available under a MIT License; see
the LICENSE file for the text of the MIT License.


## Caveats

So far (2024-02-05) this Formula has only been very lightly
tested, and only on macOS Ventura (13).  It relies on the
macOS system perl, which ships with several CPAN modules
pre installed.  Some of those preinstalled CPAN modules
are relied on.

Since only the core perl dependencies are installed it is
likely that anything other than command line usage will not
work.
