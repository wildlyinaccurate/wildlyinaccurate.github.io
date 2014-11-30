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
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>Setting up a web server with Apache, PHP, and MySQL on any Debian-based system is really easy thanks to APT (Advanced Packaging Tool). Follow along and you'll have a web server set up within fifteen minutes.<!--more--></p>
<h4>Requirements</h4>
<ul>
<li>apt-get</li>
<li>root privileges, or sudo</li>
<li>70MB free space</li>
<li>15 minutes</li>
</ul>
<h4>Install Apache</h4>
<pre class="no-highlight">sudo apt-get install apache2</pre>
<h4>Enabling .htaccess overrides</h4>
<p>.htaccess overrides are a common component of many web applications. To enable .htaccess overrides, first open /etc/apache2/sites-available/default with the text editor of your choice (e.g. <code>sudo nano /etc/apache2/sites-available/default</code>). Inside the <code>&lt;VirtualHost *:80&gt;</code> section, set <code>AllowOverride</code> to <code>All</code>.</p>
<p>Next, create a symbolic link to the rewrite module in the mods-enabled directory:</p>
<pre class="no-highlight">sudo ln -s /etc/apache2/mods-available/rewrite.load /etc/apache2/mods-enabled/rewrite.load</pre>
<p>Now restart Apache for the changes to take effect (see <a href="#starting-and-stopping-the-web-server">Starting and stopping the web server</a>).</p>
<h4>Install PHP</h4>
<pre class="no-highlight">sudo apt-get install php5
sudo apt-get install libapache2-mod-php5</pre>
<p>Note that the php5 package may already include libapache2-mod-php5, so the second command might not be required.</p>
<h4>Install MySQL</h4>
<pre class="no-highlight">sudo apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql</pre>
<h4 id="starting-and-stopping-the-web-server">Starting and stopping the web server</h4>
<p>After installing everything, you should restart Apache to make sure it reads your updated configuration file. Simply use <code>sudo apache2ctl graceful-stop</code> to stop the server and <code>sudo apache2ctl start</code> to start it again. (It is good to get into the habit of doing a <code>graceful-restart</code> instead of a plain <code>restart</code>, as well as doing a <code>graceful-stop</code> instead of a regular <code>stop</code>.)</p>
<h3>Optional Extras</h3>
<p>Below is a list of useful tools and modules that I recommend installing. Remember to restart your web server after installing a new module.</p>
<h4>PhpMyAdmin</h4>
<p>PhpMyAdmin is an in-browser MySQL administration interface written in PHP. Installing PhpMyAdmin will require an extra 20MB of disk space, as it is dependant on several other packages.</p>
<pre class="no-highlight">sudo apt-get install phpmyadmin</pre>
<p>Once PhpMyAdmin is installed, open /etc/apache2/apache2.conf with the text editor of your choice (e.g. <code>sudo nano /etc/apache2/apache2.conf</code>) and add this line at the bottom of the file:</p>
<pre class="no-highlight">Include /etc/phpmyadmin/apache.conf</pre>
<h4>APC</h4>
<p>APC (Alternative PHP Cache) can provide significant performance boosts to PHP applications by optimising and caching PHP intermediate code. I highly recommend installing APC as it a great caching mechanism and will even be <a href="http://en.wikipedia.org/wiki/List_of_PHP_accelerators#Alternative_PHP_Cache_.28APC.29">built into the PHP core as of version 5.4</a>.</p>
<pre class="no-highlight">sudo apt-get install php-apc</pre>
<p>The APC team have written a script which is useful for monitoring the cache and fine-tuning settings. Unfortunately the script isn't downloaded when you install APC using apt-get, but you can <a href="http://pastebin.com/GKSyafs1">get the script here</a>.</p>
<h4>cURL</h4>
<p>cURL is a PHP library that allows you to communicate with different types of servers using many protocols including http, https, ftp, telnet, ldap, and more. cURL is especially useful for making API calls.</p>
<pre class="no-highlight">sudo apt-get install php5-curl</pre>
<h4>PHP GD</h4>
<p>The GD library allows you to create and manipulate images in various formats including <acronym title="Graphic Interchange Format">GIF</acronym>, <acronym title="Portable Network Graphics">PNG</acronym>, <acronym title="Joint Photographic Experts Group">JPEG</acronym>, <acronym title="Wireless Bitmap">WBMP</acronym>, and <acronym title="X PixMap">XPM</acronym>. It is almost essential for any image processing like cropping and resizing.</p>
<pre class="no-highlight">sudo apt-get install php5-gd</pre>
