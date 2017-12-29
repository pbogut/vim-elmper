[![Project Status: WIP - Initial development is in progress, but there has not yet been a stable, usable release suitable for the public.](http://www.repostatus.org/badges/latest/wip.svg)](http://www.repostatus.org/#wip)

# Vim Elmper
Stands for **Vim** **Elm** Hel**per** (yeah, that's cheap)

-----

## What is it?

It's work in progress, for now it can install missing packages, but there is
plan for more.

### Install Missing Packages

To install missing packages use `ElmperInstallMissingPackages` command. It looks
for imports in current file and if package providing given module is not installed
it will try to install it. For example if you add `import Mouse` in new `elm` file
and run this command it will do `elm-package install elm-lang/keyboard --yes`.
