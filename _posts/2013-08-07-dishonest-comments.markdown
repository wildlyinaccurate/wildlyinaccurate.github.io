---
layout: post
title: Dishonest comments
date: 2013-08-07 22:07:02.000000000 +01:00
categories:
- Thoughts
tags:
- comments
status: publish
type: post
published: true
author: Joseph Wynn
---

One of my favourite Ruby Rogues episodes ([_What Makes Beautiful Code_](http://rubyrogues.com/what-makes-beautiful-code/)) has a short section where the Rogues talk about the concept of _dishonest code_. David Brady wrote a [really good piece](http://chalain.livejournal.com/39332.html) on this, which I highly recommend reading.

What I want to talk about is a more specific variant of dishonest code: dishonest comments.

Take this code, for example:

<pre class="highlight-js">$('a').click(function(e) {
    e.stopPropagation();
    e.preventDefault();
});</pre>

If you're not familiar with JavaScript events, `e.stopPropagation()` will stop this event from bubbling up to other event handlers. Now, what if somebody decides that the event _should_ bubble up? They might do something like this:

<pre class="highlight-diff diff">--- a/example.js
+++ b/example.js
@@ -1,4 +1,4 @@
 $('a').click(function(e) {
+    // Let the event bubble up to the next handler
-    e.stopPropagation();
     e.preventDefault();
 });</pre>

This is pretty common practice; a developer will leave a comment so that the next person understands why the `e.stopPropagation()` is gone.<!--more-->

So far this isn't too bad. But what happens when somebody changes their mind again, and doesn't want the event to bubble up anymore? Quite often, this is what happens:

<pre class="highlight-diff diff">--- a/example.js
+++ b/example.js
@@ -1,4 +1,5 @@
 $('a').click(function(e) {
     // Let the event bubble up to the next handler
+    e.stopPropagation();
     e.preventDefault();
 });</pre>

The `e.stopPropagation()` call is added back in, right where it was before. You can see the problem here: the comment explaining that the event will bubble up is still there.

A lot of developers tend to ignore comments in code, especially comments that were written by somebody else. Modern text editors and IDEs are partly to blame for this, since their syntax highlighting tends to de-emphasise comments by greying them out.

<pre class="highlight-js">$('a').click(function(e) {
    // Let the event bubble up to the next handler
    e.stopPropagation();
    e.preventDefault();
});</pre>

What we've ended up with is a comment which says one thing, and some code which does something _entirely different_. This is surprisingly common -- most codebases are absolutely _littered_ with dishonest comments.

The example I've given above might seem contrived, but this is an entirely real —although somewhat simplified— example of some code that I had to debug recently.

Dishonest comments can confuse even the most experienced developers, and make debugging much more difficult than it needs to be. Figuring out what one line of code is _supposed_ to do can turn into an hour of trawling through version control logs and diffs.

The worst part about dishonest comments is that the problems they cause aren't immediately obvious. Unit tests won't pick them up. A full regression test won't find them. Once they're committed to the codebase, they remain hidden right up until the point where you realise that they're lying to you.

So really, the only way to avoid dishonest comments is to simply **not write them in the first place**.

<span style="line-height: 1.6;">In the Ruby Rogues episode I mentioned at the start of this post, there's a brief discussion about the idea that comments are a code smell. This idea is </span>[hotly debated](http://programmers.stackexchange.com/questions/1/comments-are-a-code-smell).<span style="line-height: 1.6;"> However, I do believe that treating comments as a code smell can help you to identify dishonest comments before they become a problem.</span>

I think this ends up coming back to the way that syntax highlighting hides comments from us. It's really difficult to spot dishonest comments because we've trained our brains to focus on the bright &amp; colourful text, and ignore the dull grey text.

{% image path: assets/hidden-comments.png alt: "Greyed-out comments" %}

If you opened this file to make some changes, chances are you wouldn't even notice the comments, let alone figure out that they are all lies. But what if the comments stood out more?

I'm currently experimenting with my own variation of the Monokai colour scheme which draws comments in a bright colour.

{% image path: assets/bright-comments.png alt: "Bright comments" %}

Suddenly the comments stand out. They even stand out more than most of the actual code in this file. To me, this is a good thing because comments should only be there to say something important that the code can't say by itself. If there is a comment in the code, I want it to stand out because it must be telling me something **really important**.

Having the comments stand out more also makes it much more obvious when there are too many comments. Usually, seeing a lot of comments tells me that either:

1.  Most of these comments are unnecessary, or,
2.  The code needs to be refactored to be self-documenting

If the comments are unnecessary, they can be removed. If the code can be more self-documenting, then the comments that _were_ documenting it can be removed. Either way, you end up with less comments, and less dishonesty.

How you deal with dishonest comments in your codebase is up to you. In the end though, it's down to you and your team to be more thoughtful about the comments that you write. If an honest comment can be turned into a dishonest comment simply by changing the code around it, then you probably need to re-think whether that comment is necessary.
