---
layout: post
title: Setting up a Web Server on Ubuntu/Debian
date: 2011-07-23 00:59:09.000000000 +01:00
categories:
- Linux
- Server Administration
- Web Development
tags:
- apache
- apt-get
- debian
- mysql
- php
- phpmyadmin
- ubuntu
- web server
status: publish
type: post
published: true
author: Joseph Wynn
---

Setting up a web server with Apache, PHP, and MySQL on any Debian-based system is really easy thanks to APT (Advanced Packaging Tool). Follow along and you'll have a web server set up within fifteen minutes.<!--more-->

#### Requirements

*   apt-get
*   root privileges, or sudo
*   70MB free space
*   15 minutes

#### Install Apache

<pre>sudo apt-get install apache2</pre>

#### Enabling .htaccess overrides

.htaccess overrides are a common component of many web applications. To enable .htaccess overrides, first open /etc/apache2/sites-available/default with the text editor of your choice (e.g. `sudo nano /etc/apache2/sites-available/default`). Inside the `<VirtualHost *:80>` section, set `AllowOverride` to `All`.

Next, create a symbolic link to the rewrite module in the mods-enabled directory:

<pre>sudo ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load</pre>

Now restart Apache for the changes to take effect (see [Starting and stopping the web server](#starting-and-stopping-the-web-server)).

#### Install PHP

<pre>sudo apt-get install php5
sudo apt-get install libapache2-mod-php5</pre>

Note that the php5 package may already include libapache2-mod-php5, so the second command might not be required.

#### Install MySQL

<pre>sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql</pre>

#### Starting and stopping the web server

After installing everything, you should restart Apache to make sure it reads your updated configuration file. Simply use `sudo apache2ctl graceful-stop` to stop the server and `sudo apache2ctl start` to start it again. (It is good to get into the habit of doing a `graceful-restart` instead of a plain `restart`, as well as doing a `graceful-stop` instead of a regular `stop`.)

### Optional Extras

Below is a list of useful tools and modules that I recommend installing. Remember to restart your web server after installing a new module.

#### PhpMyAdmin

PhpMyAdmin is an in-browser MySQL administration interface written in PHP. Installing PhpMyAdmin will require an extra 20MB of disk space, as it is dependant on several other packages.

<pre>sudo apt-get install phpmyadmin</pre>

Once PhpMyAdmin is installed, open /etc/apache2/apache2.conf with the text editor of your choice (e.g. `sudo nano /etc/apache2/apache2.conf`) and add this line at the bottom of the file:

<pre>Include /etc/phpmyadmin/apache.conf</pre>

#### APC

APC (Alternative PHP Cache) can provide significant performance boosts to PHP applications by optimising and caching PHP intermediate code. I highly recommend installing APC as it a great caching mechanism and will even be [built into the PHP core as of version 5.4](http://en.wikipedia.org/wiki/List_of_PHP_accelerators#Alternative_PHP_Cache_.28APC.29).

<pre>sudo apt-get install php-apc</pre>

The APC team have written a script which is useful for monitoring the cache and fine-tuning settings. Unfortunately the script isn't downloaded when you install APC using apt-get, but you can [get the script here](http://pastebin.com/GKSyafs1).

#### cURL

cURL is a PHP library that allows you to communicate with different types of servers using many protocols including http, https, ftp, telnet, ldap, and more. cURL is especially useful for making API calls.

<pre>sudo apt-get install php5-curl</pre>

#### PHP GD

The GD library allows you to create and manipulate images in various formats including <acronym title="Graphic Interchange Format">GIF</acronym>, <acronym title="Portable Network Graphics">PNG</acronym>, <acronym title="Joint Photographic Experts Group">JPEG</acronym>, <acronym title="Wireless Bitmap">WBMP</acronym>, and <acronym title="X PixMap">XPM</acronym>. It is almost essential for any image processing like cropping and resizing.

<pre>sudo apt-get install php5-gd</pre>
