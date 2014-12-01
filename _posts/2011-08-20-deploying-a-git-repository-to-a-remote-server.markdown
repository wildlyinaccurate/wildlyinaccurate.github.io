---
layout: post
title: Deploying a Git repository to a remote server
date: 2011-08-20 17:58:22.000000000 +01:00
categories:
- Git
- Linux
- Server Administration
tags:
- archive
- deploy
- export
- git
- remote
- server
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>Git's <code>archive</code> command is basically the equivalent of SVN's <code>export</code> – it dumps a copy of the entire repository without any of the version control files, making it perfect for deploying to a testing or production server.<!--more--></p>
<p>Using a combination of <code>git archive</code>, SSH, and Gzip; deploying a Git repository to a remote server can be done quickly and easily:</p>
<pre class="no-highlight">git archive --format=tar origin/master | gzip -9c | ssh user@yourserver.com "tar --directory=/var/www -xvzf -"</pre>
<p>Let's take a look at the different parts of that command.</p>
<p><strong>--format=tar</strong><br />
This tells Git to combine all of the repository's files into a single tarball file. The benefit of doing this is that a large single file can be transferred much quicker than thousands of smaller files.</p>
<p><strong>origin/master</strong><br />
If you are familiar with Git, you should recognise that these are the default names for a Git remote and branch. You should change these to match your remote/branch setup.</p>
<p><strong>gzip -9c</strong><br />
The tarball created by <code>git archive</code> is piped into Gzip, which applies compression to reduce the size of the file. The <code>9</code> flag tells Gzip to use the best compression method, and the <code>c</code> flag makes Gzip write the compressed file to <abbr title="Standard Output">stdout</abbr>. The reason we want Gzip to write to standard output is so that we can send the compressed repository straight to the remote server via SSH.</p>
<p><strong>ssh user@yourserver.com "tar --directory=/var/www -xvzf -"</strong><br />
The Gzipped tarball is then piped through SSH to your remote server. The remote server runs <code>tar --directory=/var/www -xvzf -</code> which extracts the Gzipped tarball into the <code>/var/www</code> directory. Note that the hyphen (<code>-</code>) at the end of the <code>tar</code> command tells tar to receive data from a piped command instead of a file.</p>
<p>...And that's all there is to it! Using this command I am able to compress a 25MB repository down to 1MB and deploy it in less than 10 seconds. I hope you find it just as useful.</p>
