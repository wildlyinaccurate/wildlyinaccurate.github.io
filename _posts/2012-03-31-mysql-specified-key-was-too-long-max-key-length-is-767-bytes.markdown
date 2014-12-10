---
layout: post
title: 'MySQL: Specified key was too long; max key length is 767 bytes'
date: 2012-03-31 14:21:04.000000000 +01:00
categories:
- MySQL
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---

MySQL has a [prefix limitation](http://dev.mysql.com/doc/refman/5.1/en/create-index.html) of 767 bytes in InnoDB, and 1000 bytes in MyISAM. This has never been a problem for me, until I started using UTF-16 as the character set for one of my databases. UTF-16 can use up to 4 bytes per character which means that in an InnoDB table, you can't have any keys longer than 191 characters. Take this `CREATE` statement for example:

<pre>CREATE TABLE `user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `password` varchar(64) NOT NULL,
  `email` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UNIQ_8D93D649F85E0677` (`username`),
  UNIQUE KEY `UNIQ_8D93D649E7927C74` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf16 AUTO_INCREMENT=1 ;</pre>

This will fail with an error like `Specified key was too long; max key length is 767 bytes`, because the `UNIQUE INDEX` on the email field requires at least 1020 bytes (255 * 4).

Unfortunately there is no real solution to this. Your only options are to either reduce the size of the column, use a different character set (like UTF-8), or use a different engine (like MyISAM). In this case I switched the character set to UTF-8 which raised the maximum key length to 255 characters.
