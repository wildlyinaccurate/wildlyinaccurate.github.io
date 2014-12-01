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
<p>When you <code>apt-get install php5</code> on a Debian/Ubuntu server, you'll notice that APT will automatically install a bunch of <code>apache2</code> packages as well. This can be pretty annoying if you're planning on using another web server (or no web server at all).</p>
<p>If you take a look at the package dependencies (<a href="http://packages.debian.org/wheezy/php5">Debian</a>/<a href="http://packages.ubuntu.com/quantal/php5">Ubuntu</a>) you'll see why this happens - <code>php5</code> needs one of either <code>libapache2-mod-php5</code>, <code>libapache2-mod-php5filter</code>, <code>php5-cgi</code>, or <code>php5-fpm</code>. APT doesn't care which package it installs; it just picks the first package that satisfies the dependency, which is why you get the <code>apache2</code> packages.</p>
<p>You can get around this by installing one of the other dependencies <em>before</em> <code>php5</code>. For example, <code>apt-get install php5-fpm php5</code> or <code>apt-get install php5-cgi php5</code>.</p>
