---
layout: post
title: Converting Bootswatch themes to SASS/SCSS
date: 2013-09-06 15:24:49.000000000 +01:00
categories:
- Web Development
tags:
- bootstrap
- bootswatch
- scss
status: publish
type: post
published: true
author: Joseph Wynn
---

There's a fairly quick way to convert Bootswatch themes to Sass (which you might want to do if you use something like [sass-bootstrap](https://github.com/jlong/sass-bootstrap)).

Simply download the theme's variables.less and run the following find/replace patterns against it:

### Variables

Find (regex): `@([a-zA-Z0-9_-]+)`

Replace: `\$$1`

### Mixins

Find: `spin(`

Replace: `adjust-hue(`

This is all I've found in the themes that I've tried.