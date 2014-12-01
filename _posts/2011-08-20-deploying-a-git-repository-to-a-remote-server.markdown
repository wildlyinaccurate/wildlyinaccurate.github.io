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

Git's `archive` command is basically the equivalent of SVN's `export` – it dumps a copy of the entire repository without any of the version control files, making it perfect for deploying to a testing or production server.<!--more-->

Using a combination of `git archive`, SSH, and Gzip; deploying a Git repository to a remote server can be done quickly and easily:

<pre class="no-highlight">git archive --format=tar origin/master | gzip -9c | ssh user@yourserver.com "tar --directory=/var/www -xvzf -"</pre>

Let's take a look at the different parts of that command.

**--format=tar**

This tells Git to combine all of the repository's files into a single tarball file. The benefit of doing this is that a large single file can be transferred much quicker than thousands of smaller files.

**origin/master**

If you are familiar with Git, you should recognise that these are the default names for a Git remote and branch. You should change these to match your remote/branch setup.

**gzip -9c**

The tarball created by `git archive` is piped into Gzip, which applies compression to reduce the size of the file. The `9` flag tells Gzip to use the best compression method, and the `c` flag makes Gzip write the compressed file to <abbr title="Standard Output">stdout</abbr>. The reason we want Gzip to write to standard output is so that we can send the compressed repository straight to the remote server via SSH.

**ssh user@yourserver.com "tar --directory=/var/www -xvzf -"**

The Gzipped tarball is then piped through SSH to your remote server. The remote server runs `tar --directory=/var/www -xvzf -` which extracts the Gzipped tarball into the `/var/www` directory. Note that the hyphen (`-`) at the end of the `tar` command tells tar to receive data from a piped command instead of a file.

...And that's all there is to it! Using this command I am able to compress a 25MB repository down to 1MB and deploy it in less than 10 seconds. I hope you find it just as useful.
