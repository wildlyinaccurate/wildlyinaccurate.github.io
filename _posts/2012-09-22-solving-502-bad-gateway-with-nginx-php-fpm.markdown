---
layout: post
title: Solving "502 Bad Gateway" with nginx & php-fpm
date: 2012-09-22 21:15:00.000000000 +01:00
categories:
- Server Administration
tags:
- '502'
- bad gateway
- nginx
- php
- php-fpm
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
<p>After upgrading php-fpm, my PHP-based sites were returning "502 Bad Gateway" errors. This can happen when the php5-fpm package reconfigures itself to listen on a different socket. Here's how you can solve it.</p>
<p>Check to make sure that php-fpm is running with <code>ps aux | grep php</code> - if you can't see any php-fpm processes in the output, then you may need to re-install php-fpm. If php-fpm is running okay, then skip this first step.</p>
<pre class="no-highlight">sudo apt-get remove php5 php5-cgi php5-fpm
sudo apt-get install php5 php5-cgi php5-fpm</pre>
<p>The thing to notice here is that the order in which you install the packages is important. In the past I have found that installing them in the wrong order causes the packages to be configured incorrectly.</p>
<p>Next, get php-fpm to listen on the correct host/port. In <code>/etc/php5/fpm/pool.d/www.conf</code> change the <code>listen</code> value to match the <code>fastcgi_pass</code> location in your Nginx configuration. For example, I changed mine from:</p>
<pre class="no-highlight">listen = /var/run/php5-fpm.sock</pre>
<p>To:</p>
<pre class="no-highlight">listen = 127.0.0.1:9000</pre>
<p>If you are configuring php-fpm to listen on a Unix socket, you should also check that the socket file has the correct owner and permissions. While I wouldn't recommend it, you can simply give read-write permissions to all with <code>sudo chmod go+rw /var/run/php5-fpm.sock</code>.</p>
<p>Restart php-fpm with <code>sudo service php5-fpm restart</code> and everything should work normally again.</p>
