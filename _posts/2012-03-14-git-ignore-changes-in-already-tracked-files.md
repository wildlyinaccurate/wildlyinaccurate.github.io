---
layout: post
title: 'Git: Ignore changes to already-tracked files'
date: 2012-03-14 10:53:30.000000000 +00:00
categories:
- Git
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---

There are often times when you want to modify a file but not commit the changes, for example changing the database configuration to run on your local machine.

Adding the file to .gitignore doesn't work, because the file is already tracked. Luckily, Git will allow you to manually "ignore" changes to a file or directory:

```
git update-index --assume-unchanged <file>
```

And if you want to start tracking changes again, you can undo the previous command using:

```
git update-index --no-assume-unchanged <file>
```

Easy!
