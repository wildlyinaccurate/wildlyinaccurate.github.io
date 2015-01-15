---
layout: post
title: Converting an SVN repository to Git
date: 2012-02-08 10:40:17.000000000 +00:00
categories:
- Git
- SVN
tags:
- git
- git-svn
- svn
status: publish
type: post
published: true
author: Joseph Wynn
---

Today I found out just how easy it is to convert an SVN repository to Git without losing any commit history. Note that you will need [git-svn](http://schacon.github.com/git/git-svn.html) (`apt-get install git-svn` on Debian/Ubuntu).

```
git svn clone http://mysvnrepo.com/my-project my-project
cd my-project
git remote add origin git@mygitrepo.com:/my-project.git
git push origin master
```

Et voilà, my-project.git has the full commit history of the my-project SVN repository.

If anybody knows whether SVN branches can be converted to Git branches, please get in touch!
