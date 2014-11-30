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
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>There's a fairly quick way to convert Bootswatch themes to Sass (which you might want to do if you use something like <a href="https://github.com/jlong/sass-bootstrap">sass-bootstrap</a>).</p>
<p>Simply download the theme's variables.less and run the following find/replace patterns against it:</p>
<h3>Variables</h3>
<p>Find (regex): <code>@([a-zA-Z0-9_-]+)</code><br />
Replace: <code>\$$1</code></p>
<h3>Mixins</h3>
<p>Find: <code>spin(</code><br />
Replace: <code>adjust-hue(</code></p>
<p>This is all I've found in the themes that I've tried.</p>
