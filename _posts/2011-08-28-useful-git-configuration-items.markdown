---
layout: post
title: Useful Git Configuration Items
date: 2011-08-28 18:09:59.000000000 +01:00
categories:
- Git
tags:
- configuration
- git
- global
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
<h2 id="name-and-email-address">Name and email address</h2>
<p>Each commit you make has your name and email address attached to it. Git will automatically configure these based on your username and hostname, but this information is usually not a good identifier. It is a good idea to set your real name and email address so that your commits can be identified easily.</p>
<pre class="no-highlight">git config --global user.name "Your Name"
git config --global user.email you@yourdomain.com</pre>
<h2 id="global-ignore-file">Global ignore file</h2>
<p>Often there are files or directories that you want Git to ignore globally. These are probably created automatically by your IDE or operating system. Git's <code>core.excludesfile</code> config allows you to write a global .gitignore so that you don't have to fill local .gitignore files with clutter.</p>
<pre class="no-highlight">git config --global core.excludesfile /path/to/.gitignore_global</pre>
<p><!--more--></p>
<h2 id="enable-coloured-output">Enable coloured output</h2>
<pre class="no-highlight">git config --global color.ui true</pre>
<h2 id="prevent-line-ending-issues">Prevent line ending issues</h2>
<p><strong>On Linux and Mac</strong></p>
<pre class="no-highlight">git config --global core.autocrlf input</pre>
<p><strong>On Windows</strong></p>
<pre class="no-highlight">git config --global core.autocrlf true</pre>
<p>See <a href="http://help.github.com/line-endings/">http://help.github.com/line-endings/</a> for more information.</p>
<h2 id="add-svn-like-shortcuts">Add SVN-like shortcuts</h2>
<pre class="no-highlight">git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch</pre>
<h2 id="better-compression">Better compression</h2>
<pre class="no-highlight">git config --global core.compression 9</pre>
<p>If you find that Git is taking too long to compress objects, you can play around with this value. A value of 0 tells Git to use no compression. Values 1-9 are various speed/size tradeoffs where 1 is the fastest and 9 provides the best compression. A value of -1 lets zlib decide which compression level to use.</p>
<h2 id="automatically-rebase-pulls">Automatically rebase pulls</h2>
<pre class="no-highlight">git config --global branch.autosetuprebase always</pre>
<p>You can avoid having messy "Merge branch 'master' into ..." commits by rebasing every time you pull. This configuration item essentially performs a <code>git pull --rebase</code> every time you do <code>git pull</code>.</p>
