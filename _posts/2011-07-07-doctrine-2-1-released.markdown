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
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>Doctrine 2.1 has been released, bringing many major changes to the ORM - some of which are not backwards-compatible with Doctrine 2.0.<!--more--></p>
<p>Some of the changes that I thought were of particular interest are:</p>
<ul>
<li>The use of the Symfony console, which will require some re-configuration in the Doctrine bootstrap script.</li>
<li>A much more powerful AnnotationReader, which has <a href="http://www.doctrine-project.org/docs/common/2.1/en/reference/annotations.html">many new features</a>.</li>
<li>Read-only entities, which can be created and deleted but not updated. These entities are not considered in the UnitOfWork changeset computations which allows for significant performance optimisations.</li>
<li>The EntityRepository::findBy() method now accepts orderBy, limit, and offset parameters.</li>
</ul>
<p>Read Doctrine's <a href="http://www.doctrine-project.org/blog/doctrine-2-1">official blog post</a> and <a href="http://www.doctrine-project.org/projects/orm/2.1/docs/whats-new/en"><em>What's New</em> document</a> for more information.</p>
<p>I will be updating my <a href="https://wildlyinaccurate.com/codeigniter-2doctrine-2-installation/">CodeIgniter 2/Doctrine 2 Installation</a> post in the next few days to include Doctrine 2.1.</p>
