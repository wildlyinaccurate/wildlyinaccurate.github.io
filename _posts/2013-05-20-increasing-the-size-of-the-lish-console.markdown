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
<p>If you've used Linode's LISH console to get remote access to your server, you're probably familiar with the way the console wraps everything to 60x20 (columns x rows) - even when you're connected via ssh in a much larger terminal.</p>
<p>[caption id="attachment_742" align="aligncenter" width="640"]<a href="https://wildlyinaccurate.com/wp-content/uploads/2013/05/lishwrap1.png"><img class=" wp-image-742 " alt="LISH Wrapping" src="assets/lishwrap1.png" width="640" height="36" /></a> Everything looks fine until...[/caption]</p>
<p>[caption id="attachment_743" align="aligncenter" width="640"]<a href="https://wildlyinaccurate.com/wp-content/uploads/2013/05/lishwrap2.png"><img class=" wp-image-743" alt="LISH Wrapping" src="assets/lishwrap2.png" width="640" height="36" /></a> ... The terminal wraps on itself[/caption]</p>
<p style="text-align: center;">
<p>Luckily, the fix is easy. The LISH console is essentially emulating a raw serial port connected to the server. The serial port itself has no natural size, so the terminal gives it a default safe size (60x20). We can tell the terminal to change this size, using the <a href="http://unixhelp.ed.ac.uk/CGI/man-cgi?stty"><code>stty</code></a> command:</p>
<pre class="highlight-bash">stty cols 200 rows 75</pre>
<p>It's as simple as that. Just set the <code>cols</code> and <code>rows</code> values to whatever size suits you.</p>
<p>If you're having to do this a lot, you might consider putting this into your <code>~/.bashrc</code> so that it runs each time you open a connection.</p>
