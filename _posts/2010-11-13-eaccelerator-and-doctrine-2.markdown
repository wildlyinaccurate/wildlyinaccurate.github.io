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
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>A word of warning: eAccelerator does not play well with Doctrine 2. This came to my attention today after I installed eAccelerator so that I could measure the performance gains (if any). As it turns out, one of eAccelerator's "features" is to remove Docblocks from PHP scripts - probably to reduce compile times. Suddenly my application was throwing exceptions with the message "Class <em>X</em> is not a valid entity or mapped super class".</p>
<p><!--more--></p>
<p>There are ways to configure eAccelerator to ignore Docblocks when "optimising" your code (see <a href="http://eaccelerator.net/ticket/229">this bug report</a>), but I think it is absurd that eAccelerator makes it so difficult to use Docblocks -- beberlei from the Doctrine team summed the issue up pretty well:</p>
<blockquote><p><em>"I think it is a very bad style to remove the docblocks from the opcode. The performance gain is probably unmeasurable, however it will severly break applications that rely on the Docblocks (a language feature!! removed). Currently opensource projects using Docblocks are getting more and more:</em></p>
<ul>
<li><em>Doctrine 2</em></li>
<li><em>Zend Framework</em></li>
<li><em>Symfony 2</em></li>
<li><em>Flow3</em></li>
<li><em>PHPUnit</em></li>
<li><em>and many more...</em></li>
</ul>
<p><em>This premature optimization to remove the docblocks should be reverted. Docblocks are a PHP Token for a reason, they are part of the language and should be used that way. Please revise your stand on this otherwise projects must suggest NOT to use eAccelerator by default."</em></p></blockquote>
<p>The bottom line is this: if you are mapping your Doctrine 2 entities using Docblock annotations; you will save yourself a lot of time and stress by <strong>not using eAccelerator</strong>.</p>
<p>Handy tip: to see if eAccelerator is loaded in your PHP installation, call <code>print_r(get_loaded_extensions());</code> and see if eAccelerator is in the array. To disable eAccelerator, open your php.ini file and find <code>zend_extension = "/path/to/extensions/php_eaccelerator.dll"</code>. Put a semicolon (;) in front of it to comment it out, and restart your web server.</p>
