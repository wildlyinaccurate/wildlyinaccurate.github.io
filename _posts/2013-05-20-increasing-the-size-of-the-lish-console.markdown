---
layout: post
title: Increasing the size of the LISH console
date: 2013-05-20 09:01:25.000000000 +01:00
categories:
- Server Administration
tags:
- linode
- lish
- ssh
- stty
status: publish
type: post
published: true
author: Joseph Wynn
---

If you've used Linode's LISH console to get remote access to your server, you're probably familiar with the way the console wraps everything to 60x20 (columns x rows) - even when you're connected via ssh in a much larger terminal.

{% image src: /assets/lishwrap1.png alt: "LISH Wrapping" %} Everything looks fine until...

{% image src: /assets/lishwrap2.png alt: "LISH Wrapping" %} ... The terminal wraps on itself

<p>Luckily, the fix is easy. The LISH console is essentially emulating a raw serial port connected to the server. The serial port itself has no natural size, so the terminal gives it a default safe size (60x20). We can tell the terminal to change this size, using the [`stty`](http://unixhelp.ed.ac.uk/CGI/man-cgi?stty) command:

<pre class="highlight-bash">stty cols 200 rows 75</pre>

It's as simple as that. Just set the `cols` and `rows` values to whatever size suits you.

If you're having to do this a lot, you might consider putting this into your `~/.bashrc` so that it runs each time you open a connection.
