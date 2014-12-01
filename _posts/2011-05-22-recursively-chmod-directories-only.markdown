`---
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
<p>The <code>find</code> utility's -exec flag makes it very easy to recursively perform operations on specific files or directories.</p>
<pre>find . -type d -exec chmod 755 {} \;</pre>
<p>This command finds all directories (starting at 'dot' - the current directory) and sets their permissions to 755 (rwxr-xr-x).</p>
<pre>find . -type f -exec chmod 644 {} \;</pre>
<p>Similarly, this command finds all files and sets their permissions to 644 (rw-r--r--).</p>
<p>&nbsp;</p>
<p>Thanks to <a href="http://movabletripe.com/archive/recursively-chmod-directories-only/">moveabletripe</a> for the info.</p>
