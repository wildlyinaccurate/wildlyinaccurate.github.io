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
author: Joseph Wynn
---

There are several ways to set up virtual hosts on your web server. One of the more common methods is to manually create a `[<VirtualHost>](http://httpd.apache.org/docs/2.0/mod/core.html#virtualhost)` record for each virtual host. While using this method is fine, it can end you up with a huge configuration file that is difficult to manage.

Because all of my virtual hosts are sub-directories of my web server's base directory, I prefer to dynamically allocate the virtual host directory based on the host name. For example, I want wildlyinaccurate.localhost to point to /var/www/wildlyinaccurate. This can be achieved by modifying the .htaccess file of your web server's base directory:<!--more-->

```
Options +FollowSymlinks
RewriteEngine On
RewriteBase /

RewriteCond %{HTTP_HOST} ^([^\.]+)\.localhost$
RewriteCond /var/www/%1 -d
RewriteRule ^(.*)$ %1/$1 [L]
```

Let me explain what this does:

`RewriteCond %{HTTP_HOST} ^([^\.]+)\.localhost$` looks for _something_.localhost and captures the first part of the host name.

`RewriteCond /var/www/%1 -d` makes sure that the captured string (e.g. _something_) exists and is a sub-directory of /var/www/

`RewriteRule ^(.*)$ %1/$1` simply rewrites any of our *.localhost requests to the sub-directory (e.g. /var/www/something).

So there you have it! A simple way to configure dynamic virtual hosts -- as long as they are sub-directories of your web server root! Note that this guide doesn't cover how to make *.localhost point to your web server. To do this you either need to manually add the host name into your hosts file (`/etc/hosts` on Linux; `C:\WINDOWS\system32\drivers\etc\hosts` on windows) or set up your own DNS server.
