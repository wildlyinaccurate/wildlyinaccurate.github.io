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
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>CodeIgniter 2.0.0 was <a href="http://codeigniter.com/news/codeigniter_2.0.0_released/">released today</a>, signalling a huge step forward for the already-popular PHP framework. The interesting thing about CodeIgniter 2 is that there are two branches in development: CodeIgniter Core, which is the 'official' branch developed by EllisLabs; and CodeIgniter Reactor which is a community-driven branch enabling faster adoption of new features. Reactor will essentially become CodeIgniter, as EllisLabs recommends Reactor for day to day development.<!--more--></p>
<p>So what is new in CodeIgniter 2? There are several major changes that are worth knowing about:</p>
<ul>
<li>Support for PHP 4 is (finally) gone. CodeIgniter 2 requires PHP 5.1 or higher.</li>
<li><acronym title="Cross-Site Request Forgery">CSRF</acronym> protection is now built into the form helper.</li>
<li>Plugins have been removed in favour of helpers and libraries.</li>
<li>There is now a $route['404_override'] router rule to allow 404 pages to be handled by a controller (no more hacky MY_Router libraries!)</li>
<li>Drivers, including an abstracted database class, and a javascript 'helper' class.</li>
</ul>
<p>CodeIgniter Reactor already offers several improvements over the Core branch, including:</p>
<ul>
<li>A caching driver with support for file cachine, APC, and memcache.</li>
<li>Full query string support (finally!)</li>
<li>Command line compatibility - I have been really looking forward to this feature, as running CodeIgniter applications on the command line in the past has been difficult at best.</li>
<li>Automatic base_url detection.</li>
</ul>
<p>But that's enough writing for now. I'm going to <a href="http://codeigniter.com/download.php">download</a> the latest release, and so should you!</p>
<p>P.S. Now that CodeIgniter 2 and Doctrine 2 have both been released, I will re-write my 'Implementing Doctrine 2 with CodeIgniter 2' post and include a sample application.</p>
