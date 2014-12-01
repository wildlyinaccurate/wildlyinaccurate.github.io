---
layout: post
title: Doctrine 2.1 Released
date: 2011-07-07 15:29:53.000000000 +01:00
categories:
- Doctrine
tags:
- doctrine 2.1
- orm
- release
status: publish
type: post
published: true
author: Joseph Wynn
---

Doctrine 2.1 has been released, bringing many major changes to the ORM - some of which are not backwards-compatible with Doctrine 2.0.<!--more-->

Some of the changes that I thought were of particular interest are:

*   The use of the Symfony console, which will require some re-configuration in the Doctrine bootstrap script.
*   A much more powerful AnnotationReader, which has [many new features](http://www.doctrine-project.org/docs/common/2.1/en/reference/annotations.html).
*   Read-only entities, which can be created and deleted but not updated. These entities are not considered in the UnitOfWork changeset computations which allows for significant performance optimisations.
*   The EntityRepository::findBy() method now accepts orderBy, limit, and offset parameters.

Read Doctrine's [official blog post](http://www.doctrine-project.org/blog/doctrine-2-1) and [_What's New_ document](http://www.doctrine-project.org/projects/orm/2.1/docs/whats-new/en) for more information.

I will be updating my [CodeIgniter 2/Doctrine 2 Installation](https://wildlyinaccurate.com/codeigniter-2doctrine-2-installation/) post in the next few days to include Doctrine 2.1.
