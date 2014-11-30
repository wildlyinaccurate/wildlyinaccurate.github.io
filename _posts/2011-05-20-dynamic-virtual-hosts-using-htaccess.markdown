---
layout: post
title: Dynamic Virtual Hosts Using .htaccess
date: 2011-05-20 19:11:45.000000000 +01:00
categories:
- Server Administration
tags:
- apache
- dynamic
- htaccess
- virtualhost
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
<p>There are several ways to set up virtual hosts on your web server. One of the more common methods is to manually create a <a href="http://httpd.apache.org/docs/2.0/mod/core.html#virtualhost">&lt;VirtualHost&gt;</a> record for each virtual host. While using this method is fine, it can end you up with a huge configuration file that is difficult to manage.</p>
<p>Because all of my virtual hosts are sub-directories of my web server's base directory, I prefer to dynamically allocate the virtual host directory based on the host name. For example, I want wildlyinaccurate.localhost to point to /var/www/wildlyinaccurate. This can be achieved by modifying the .htaccess file of your web server's base directory:<!--more--></p>
<pre>Options +FollowSymlinks
RewriteEngine On
RewriteBase /

RewriteCond %{HTTP_HOST} ^([^\.]+)\.localhost$
RewriteCond /var/www/%1 -d
RewriteRule ^(.*)$ %1/$1 [L]</pre>
<p>Let me explain what this does:</p>
<p><code>RewriteCond %{HTTP_HOST} ^([^\.]+)\.localhost$</code> looks for <em>something</em>.localhost and captures the first part of the host name.<br />
<code>RewriteCond /var/www/%1 -d</code> makes sure that the captured string (e.g. <em>something</em>) exists and is a sub-directory of /var/www/<br />
<code>RewriteRule ^(.*)$ %1/$1</code> simply rewrites any of our *.localhost requests to the sub-directory (e.g. /var/www/something).</p>
<p>So there you have it! A simple way to configure dynamic virtual hosts -- as long as they are sub-directories of your web server root! Note that this guide doesn't cover how to make *.localhost point to your web server. To do this you either need to manually add the host name into your hosts file (<code>/etc/hosts</code> on Linux; <code>C:\WINDOWS\system32\drivers\etc\hosts</code> on windows) or set up your own DNS server.</p>
