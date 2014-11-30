---
layout: post
title: Convert print and echo statements to short syntax
date: 2011-06-24 14:59:25.000000000 +01:00
categories:
- PHP
- Web Development
tags:
- echo
- php
- print
- regular expression
- short tags
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
<p>It's debatable whether or not it's good practice to use short syntax in PHP. I personally prefer to use short syntax because it keeps my view files looking tidy.</p>
<p>The regular expression below will find all one-liner <code>print</code> and <code>echo</code> statements (e.g. <code>&lt;?php print $var; ?&gt;</code>) and convert them to <code>&lt;?=$var?&gt;</code> statements. It will not match statements containing closing brackets, for example when using ternary operators: <code>&lt;?=($foo == $bar) ? 'Foobar' : 'Foo'?&gt;</code></p>
<pre class="no-highlight">Find:
&lt;\?php[\s]*(print|echo)[\s]*\(?([^&gt;\)]+?)\)?[\s]*;?[\s]*\?&gt;</pre>
<pre class="no-highlight">Replace:
&lt;?=$2?&gt;</pre>
