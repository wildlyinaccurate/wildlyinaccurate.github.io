---
layout: post
title: eAccelerator and Doctrine 2
date: 2010-11-13 10:18:54.000000000 +00:00
categories:
- Doctrine
- PHP
- Web Development
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---

A word of warning: eAccelerator does not play well with Doctrine 2. This came to my attention today after I installed eAccelerator so that I could measure the performance gains (if any). As it turns out, one of eAccelerator's "features" is to remove DocBlocks from PHP scripts - probably to reduce compile times. Suddenly my application was throwing exceptions with the message "Class _X_ is not a valid entity or mapped super class".

<!--more-->

There are ways to configure eAccelerator to ignore DocBlocks when "optimising" your code (see [this bug report](http://eaccelerator.net/ticket/229)), but I think it is absurd that eAccelerator makes it so difficult to use DocBlocks -- beberlei from the Doctrine team summed the issue up pretty well:

> _"I think it is a very bad style to remove the DocBlocks from the opcode. The performance gain is probably unmeasurable, however it will severely break applications that rely on the DocBlocks (a language feature!! removed). Currently open source projects using DocBlocks are getting more and more:_
>
> *   _Doctrine 2_
> *   _Zend Framework_
> *   _Symfony 2_
> *   _Flow3_
> *   _PHPUnit_
> *   _and many more..._
>
> _This premature optimization to remove the DocBlocks should be reverted. DocBlocks are a PHP Token for a reason, they are part of the language and should be used that way. Please revise your stand on this otherwise projects must suggest NOT to use eAccelerator by default."_

The bottom line is this: if you are mapping your Doctrine 2 entities using DocBlock annotations; you will save yourself a lot of time and stress by **not using eAccelerator**.

Handy tip: to see if eAccelerator is loaded in your PHP installation, call `print_r(get_loaded_extensions());` and see if eAccelerator is in the array. To disable eAccelerator, open your php.ini file and find `zend_extension = "/path/to/extensions/php_eaccelerator.dll"`. Put a semicolon (;) in front of it to comment it out, and restart your web server.
