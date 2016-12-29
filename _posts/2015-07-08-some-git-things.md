---
layout: post
title: 'Some Git Things'
categories:
- Git
tags:
- git
published: true
author: Joseph Wynn
extra_head:
  - <link rel="stylesheet" href="/css/toc.css">
---

* Placeholder list item
{:toc}

### Some notes on terminology

In case you're not familiar with some of the terminology used below, here is a small glossary.

##### Object

An object in Git is either a blob (file), tree (directory), commit, or tag. All objects in Git have a hash (like `99b69df491c0bcf5262a967313fad8be0098352e`) and are connected in a way that allows them to be modelled as a directed acyclic graph.

##### Reference

A reference in Git is a bit like a pointer, or a symlink. References are not objects themselves, and they always point to either an object or another reference. Branches, tags, and HEAD are examples of references.

You can learn about all of this and much more in my [Hacker's Guide to Git](/a-hackers-guide-to-git).<!--more-->

### Find which commit a reference points at

```
$ git rev-parse HEAD
0f64e9e759c904553309858070f444e5e64847c4

$ git rev-parse --short HEAD
0f64e9e
```

### Find which branches a commit is in

```
$ git branch --contains HEAD
  master
* other-branch
```

### Find commits which are in one branch but not another

```
$ git log --oneline --right-only master...hotfix-1

0f64e9e Apply hotfix patch from #2914 to hotfix-1
bc3bff5 [Cherry-pick] Fix issue #2926
```

##### Exclude commits which were cherry-picked

```
$ git log --oneline --cherry-pick --right-only master...hotfix-1

0f64e9e Apply hotfix patch from #2914 to hotfix-1
```

### View details of an object

```
$ git cat-file -p HEAD
tree af22d0482b89640c95986f3b4663026bcb7f764b
parent bc3bff555f573ac76f0d3e71f0e54d63f50b8434
author Foo Bar <foo@bar.com> 1436294582 +0100
committer Foo Bar <foo@bar.com> 1436294582 +0100

Lorem ipsum dolor sit amet, consectetur adipiscing elit
```

##### Show an object's type

```
$ git cat-file -t HEAD
commit
```

##### Show an object's size

```
$ git cat-file -s HEAD
253
```

### Print the tree of a given reference

```
$ git ls-tree -t -r HEAD
100644 blob 59e004af21a725c9b378001a1b231967f955b992    .gitignore
100644 blob 9f5d366d261317d8ff881ee2945ef2c7960fa2ea    .travis.yml
100644 blob 148fc67781eba8c08bbb4db1fc9e92b9781ec28d    LICENSE
100644 blob 4a2727bb9afae5782510e7ce764608540dd7c04a    Makefile
100644 blob b07b8d5f39d6f62a18a1b0791f33a784ec34556e    README.md
100644 blob 9a994af677b0dfd41b4e3b76b3e7e604003d64e1    Setup.hs
100644 blob 66820894ca2c16725e8527e16785f2eebd89871a    lishp.cabal
040000 tree eda8357ddb73fa384f283291bac84d7fe1bce436    src
040000 tree 6a84cb52f17c7e1ff691fe45f4c70df5269bdab0    src/Lishp
100644 blob 1f7677ed0c7f3e713c7e6a16d94cc3db89d911cd    src/Lishp/Interpreter.hs
100644 blob 1a0fe9394bc2d7789d783a467626301204de700a    src/Lishp/Primitives.hs
100644 blob caf0fcf1cd265436efbaa6cc39338e653197a3ee    src/Lishp/Readline.hs
100644 blob 92cf693d29169066356bed3f1ae794a624db49a5    src/Lishp/Types.hs
100644 blob 82ec4d14e01598f38a083ab2dea326615cd048dd    src/Main.hs
040000 tree ba0974cba2e671b840bb3cefa69569f62cec29b5    test
100644 blob 2589b7aeb1562a3aa951c2fa52f64891db87d1c6    test/assignment.sh
100644 blob d54fa0437e13ba5ee15ad13330ac07b9a6abcdcc    test/equality.sh
100644 blob ee61aa5dffca43032b5aeef6f4e79ff1f9f2df85    test/functions.sh
100644 blob 22fbec9189d2641c590836c4bb19431d3c6d3df3    test/primitives.sh
100644 blob c455f01b3d88b5d510ff4ebb50e93c5d7f8f0b26    test/types.sh
```

### Find the first tag which contains a reference

```
$ git describe HEAD
v1.6.1
```

### Find dangling or unreachable objects

```
$ git fsck --lost-found
Checking object directories: 100% (256/256), done.
Checking objects: 100% (153/153), done.
dangling blob b3cc2f0f4666fda6cda0f6527facbb5a7579d29e
dangling commit a621c6a60383ee430c6d21333026dd5aa7a895b0
dangling commit 4c0aab20fa5e6ba1ede09efbd9015dd8d1c54228
dangling blob 6af75568b0a8aee29c47125098b4b6d60a6a8a6f
```
