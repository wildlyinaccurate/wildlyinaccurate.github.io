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
author: Joseph Wynn
---

It's debatable whether or not it's good practice to use short syntax in PHP. I personally prefer to use short syntax because it keeps my view files looking tidy.

The regular expression below will find all one-liner `print` and `echo` statements (e.g. `<?php print $var; ?>`) and convert them to `<?=$var?>` statements. It will not match statements containing closing brackets, for example when using ternary operators: `<?=($foo == $bar) ? 'Foobar' : 'Foo'?>`

```
Find:
<\?php[\s]*(print|echo)[\s]*\(?([^>\)]+?)\)?[\s]*;?[\s]*\?>
```

```
Replace:
<?=$2?>
```
