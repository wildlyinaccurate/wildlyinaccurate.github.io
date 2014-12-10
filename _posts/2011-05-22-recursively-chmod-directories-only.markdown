---
layout: post
title: Recursively chmod Directories Only
date: 2011-05-22 23:09:38.000000000 +01:00
categories:
- Server Administration
tags:
- chmod
- directory
- find
- linux
- permissions
- unix
status: publish
type: post
published: true
author: Joseph Wynn
---

The `find` utility's -exec flag makes it very easy to recursively perform operations on specific files or directories.

<pre>find . -type d -exec chmod 755 {} \;</pre>

This command finds all directories (starting at 'dot' - the current directory) and sets their permissions to 755 (rwxr-xr-x).

<pre>find . -type f -exec chmod 644 {} \;</pre>

Similarly, this command finds all files and sets their permissions to 644 (rw-r--r--).

&nbsp;

Thanks to [moveabletripe](http://movabletripe.com/archive/recursively-chmod-directories-only/) for the info.
