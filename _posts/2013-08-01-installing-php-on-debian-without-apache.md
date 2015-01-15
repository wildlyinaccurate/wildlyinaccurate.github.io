---
layout: post
title: Installing PHP on Debian without Apache
date: 2013-08-01 18:52:36.000000000 +01:00
categories:
- Server Administration
tags:
- apache
- debian
- php
- ubuntu
status: publish
type: post
published: true
author: Joseph Wynn
---

When you `apt-get install php5` on a Debian/Ubuntu server, you'll notice that APT will automatically install a bunch of `apache2` packages as well. This can be pretty annoying if you're planning on using another web server (or no web server at all).

If you take a look at the package dependencies ([Debian](http://packages.debian.org/wheezy/php5)/[Ubuntu](http://packages.ubuntu.com/quantal/php5)) you'll see why this happens - `php5` needs one of either `libapache2-mod-php5`, `libapache2-mod-php5filter`, `php5-cgi`, or `php5-fpm`. APT doesn't care which package it installs; it just picks the first package that satisfies the dependency, which is why you get the `apache2` packages.

You can get around this by installing one of the other dependencies _before_ `php5`. For example, `apt-get install php5-fpm php5` or `apt-get install php5-cgi php5`.