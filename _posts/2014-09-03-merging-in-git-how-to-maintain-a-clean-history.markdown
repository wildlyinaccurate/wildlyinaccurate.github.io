---
layout: post
title: 'Merging in Git: How to maintain a clean history'
date: 2014-09-03 21:23:38.000000000 +01:00
categories:
- Git
tags:
- git
- merge
- rebase
status: draft
type: post
published: false
author: Joseph Wynn
---

Maintaining a clean history in Git is important for more than just aesthetic reasons.

There are two prevailing schools of thought regarding merges in Git: those who favour atomic commits, and those who favour "stream of consciousness" commits.

The former believe that each commit should be atomic -- it should contain a distinct and complete set of changes. For example, to implement Feature X, there should be a single commit "Implement feature X" which contains all the changes to implement Feature X, and nothing else.

The latter believe that in order to keep track of your development process -your stream of consciousness- you should make small commits throughout development. In contrast to atomic commits, "stream of consciousness" commits (which I'll now refer to as "non-atomic commits" for brevity) to implement Feature X might consist of several different commits:

*   "Begin implementing Feature X"
*   "Refactoring"
*   "Bug fixes"
*   "Finally finished Feature X"
*   "More bug fixes"

On the surface, there doesn't appear to be anything wrong with non-atomic commits. If you'd like to look back on the refactoring work you did as part of Feature X, you can do so by finding the "Refactoring" commit. You're not limited to seeing each commit individually, either. Once these commits have been merged into another branch, you can view all the changes together by looking at the merge commit.

So if non-atomic commits

Unfortunately the "stream of consciousness" method becomes a burden when you need to track down bugs using tools like git-bisect, or when you need to revert changes. This is because these "stream of consciousness" commits often contain unfinished or buggy code. Take the Feature X example above: checking out the "Finally finished Feature X" commit would give you the repository in a state where Feature X contains bugs -- bugs which were not fixed until the "More bug fixes" commit.