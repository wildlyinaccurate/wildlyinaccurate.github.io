---
layout: post
title: Force Bower to clone from https:// instead of git://
date: 2013-08-16 17:09:28.000000000 +01:00
categories:
- Git
tags:
- bower
- git
- https
status: publish
type: post
published: true
author: Joseph Wynn
---

Most Bower packages will be fetched using a git:// URL, which connects on port 9418. This can be problematic if you're behind a firewall which blocks this port.

You can get around this quite easily by telling Git to always use https:// instead of git://:

<pre>git config --global url.https://.insteadOf git://</pre>
