---
layout: post
title: Getting Internet Sharing to work on OSX 10.8
date: 2013-08-20 12:39:55.000000000 +01:00
categories:
- OSX
tags:
- BIND
- DNS
- Internet Sharing
- OSX
status: publish
type: post
published: true
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>I noticed that the Internet Sharing functionality didn't work on my Macbook Air (running OSX 10.8 - Mountain Lion). This is because the Air's DNS server (BIND) isn't configured correctly.</p>
<p>For me, the fix was pretty simple. Edit <code>/etc/com.apple.named.proxy.conf</code> by running <code>sudo nano /etc/com.apple.named.proxy.conf</code> in a terminal, and change</p>
<pre class="no-highlight">forward first;</pre>
<p>to</p>
<pre class="no-highlight">forward only;</pre>
<p>Then turn Internet Sharing off and on again.</p>
<p>The annoying thing is that OSX seems to restore the BIND config the next time you turn Internet Sharing off, so you need to remember to change it each time.</p>
