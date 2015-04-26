---
layout: post
title: 'Cabal: Installing readline on OSX'
categories:
- Haskell
tags:
- cabal
- readline
- osx
- homebrew
published: true
author: Joseph Wynn
---

I've had trouble installing the `readline` package on a few separate OSX installations, so I figured it was worth writing the solution down.

When running `cabal install` for a package which depends on `readline` (or simply when running `cabal install readline`), Cabal exits with errors along the lines of

```
Configuring readline-1.0.3.0...
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables...
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for GNUreadline.framework... checking for readline... no
checking for tputs in -lncurses... yes
checking for readline in -lreadline... yes
checking for rl_readline_version... yes
checking for rl_begin_undo_group... no
configure: error: readline not found, so this package cannot be built
```

The problem is that Cabal is not aware of the location of the readline lib. My workaround is to specify the location of the lib whenever running these commands:

```
$ cabal install readline --extra-include-dirs=/usr/local/Cellar/readline/6.3.8/include/ \
                         --extra-lib-dirs=/usr/local/Cellar/readline/6.3.8/lib/ \
                         --configure-option=--with-readline-includes=/usr/local/Cellar/readline/6.3.8/include/readline \
                         --configure-option=--with-readline-libraries=/usr/local/Cellar/readline/6.3.8/lib/
```

Your paths may differ slightly if you have a different version of readline installed. You can check this with

```
$ ls /usr/local/Cellar/readline
6.3.8
```
