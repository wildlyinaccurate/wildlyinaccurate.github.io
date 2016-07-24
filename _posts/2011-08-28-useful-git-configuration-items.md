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
author: Joseph Wynn
---

## Name and email address

Each commit you make has your name and email address attached to it. Git will automatically configure these based on your username and hostname, but this information is usually not a good identifier. It is a good idea to set your real name and email address so that your commits can be identified easily.

```
git config --global user.name "Your Name"
git config --global user.email you@yourdomain.com
```

## Global ignore file

Often there are files or directories that you want Git to ignore globally. These are probably created automatically by your IDE or operating system. Git's `core.excludesfile` config allows you to write a global .gitignore so that you don't have to fill local .gitignore files with clutter.

```
git config --global core.excludesfile /path/to/.gitignore_global
```

<!--more-->

## Enable coloured output

```
git config --global color.ui true
```

## Prevent line ending issues

**On Linux and Mac**

```
git config --global core.autocrlf input
```

**On Windows**

```
git config --global core.autocrlf true
```

See [http://help.github.com/line-endings/](http://help.github.com/line-endings/) for more information.

## Add SVN-like shortcuts

```
git config --global alias.st status
git config --global alias.ci commit
git config --global alias.co checkout
git config --global alias.br branch
```

## Better compression

```
git config --global core.compression 9
```

If you find that Git is taking too long to compress objects, you can play around with this value. A value of 0 tells Git to use no compression. Values 1-9 are various speed/size trade-offs where 1 is the fastest and 9 provides the best compression. A value of -1 lets zlib decide which compression level to use.

## Automatically rebase pulls

```
git config --global branch.autosetuprebase always
```

You can avoid having messy "Merge branch 'master' into ..." commits by rebasing every time you pull. This configuration item essentially performs a `git pull --rebase` every time you do `git pull`.
