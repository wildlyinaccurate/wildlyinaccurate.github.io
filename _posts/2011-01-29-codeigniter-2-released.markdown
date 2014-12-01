---
layout: post
title: CodeIgniter 2 Released
date: 2011-01-29 20:41:08.000000000 +00:00
categories:
- CodeIgniter
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---

CodeIgniter 2.0.0 was [released today](http://codeigniter.com/news/codeigniter_2.0.0_released/), signalling a huge step forward for the already-popular PHP framework. The interesting thing about CodeIgniter 2 is that there are two branches in development: CodeIgniter Core, which is the 'official' branch developed by EllisLabs; and CodeIgniter Reactor which is a community-driven branch enabling faster adoption of new features. Reactor will essentially become CodeIgniter, as EllisLabs recommends Reactor for day to day development.<!--more-->

So what is new in CodeIgniter 2? There are several major changes that are worth knowing about:

*   Support for PHP 4 is (finally) gone. CodeIgniter 2 requires PHP 5.1 or higher.
*   <acronym title="Cross-Site Request Forgery">CSRF</acronym> protection is now built into the form helper.
*   Plugins have been removed in favour of helpers and libraries.
*   There is now a $route['404_override'] router rule to allow 404 pages to be handled by a controller (no more hacky MY_Router libraries!)
*   Drivers, including an abstracted database class, and a javascript 'helper' class.

CodeIgniter Reactor already offers several improvements over the Core branch, including:

*   A caching driver with support for file cachine, APC, and memcache.
*   Full query string support (finally!)
*   Command line compatibility - I have been really looking forward to this feature, as running CodeIgniter applications on the command line in the past has been difficult at best.
*   Automatic base_url detection.

But that's enough writing for now. I'm going to [download](http://codeigniter.com/download.php) the latest release, and so should you!

P.S. Now that CodeIgniter 2 and Doctrine 2 have both been released, I will re-write my 'Implementing Doctrine 2 with CodeIgniter 2' post and include a sample application.
