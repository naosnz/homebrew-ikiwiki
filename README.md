# Homebrew packaging for ikiwki

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
a good place to start for learning how to use ikiwiki.

## Caveats

So far (2024-02-05) this Formula has only been very lightly
tested, and only on macOS Ventura (13).  It relies on the
macOS system perl, which ships with several CPAN modules
pre installed.  Some of those preinstalled CPAN modules
are relied on.

Since only the core perl dependencies are installed it is
likely that anything other than command line usage will not
work.
