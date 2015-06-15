---
layout: post
title: 'Making the BBC News website faster'
categories:
- web development
tags:
- web
- performance
published: false
author: Joseph Wynn
---

Back in March, the BBC News website [switched over to a new, fully-responsive codebase](http://responsivenews.co.uk/post/114413142693/weve-made-it). With the responsive site now delivered, we were able to dedicate some resource to looking at something which is very important to me: the performance of the website.<!--more-->

## Where are we now?

The simplest way to gauge the performance of a website is to put it next to some of your competitors. [WebPagetest](http://www.webpagetest.org/video/) makes this simple, so one of the first things we did was perform a visual comparison of BBC News and The Guardian's UK edition.

{% responsive_image path: assets/bbc-vs-guardian-filmstrip.png %}

The results were somewhat sobering. On a DSL connection, visitors from the USA who loaded up the BBC News front page would see a blank page for a full _4 seconds_ before anything started rendering. The Guardian's front page, on the other hand, starts to render in as little as _500ms_. We ended up using this comparison a lot to "sell" performance to stakeholders.

But how did we get here in the first place? The truth is that the BBC News team has spent the last few years focusing on the delivery of the responsive site, which has left virtually no room for regular performance reviews.

## Identifying performance issues

### Setting up a baseline

### Creating performance variants
