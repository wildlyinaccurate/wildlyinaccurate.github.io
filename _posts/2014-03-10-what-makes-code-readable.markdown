---
layout: post
title: Defining readable code
date: 2014-03-10 12:40:55.000000000 +00:00
categories:
- Programming
- Thoughts
tags:
- readability
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
<p>Code readability is something that I often bring up during code reviews, but I often have trouble explaining <em>why</em> I find a piece of code to be easy or difficult to read.</p>
<p>When you ask programmers how to make code easier to read, many of them will mention things like coding standards, descriptive naming, and decomposition. These things actually aid in making code easier to <em>comprehend</em> rather than easier to <em>read</em>. For me, <em>readability </em>is at a lower level, somewhere between legibility and comprehension.</p>
<p>&nbsp;</p>
<p><img class="aligncenter size-full wp-image-1017" alt="Legibility - Readability - Comprehension" src="assets/legibility-readability-comprehension.png" width="508" height="440" /></p>
<p>At the lowest level is legibility. This is how easily individual characters can be distinguished from each other, and can usually be boiled down to the choice of font, as well as the foreground &amp; background colours.</p>
<p>At the highest level is comprehension, which is the ease in which a block of code can be fully understood. Decomposition, naming conventions and comments are just a few of the many ways to improve comprehension.</p>
<p>Readability sits between these two. This level is a little harder to define, but I believe it comes down to two main factors: <strong>structure</strong> and <strong>line density</strong>.<!--more--></p>
<h2>Structure</h2>
<p>Our brains are very good at identifying structure and patterns; we find them pleasing. In the same sense, many people find a lack of structure to be quite displeasing. The effect of structure on readability can be easily demonstrated using an excerpt from this BBC article <a href="http://www.bbc.co.uk/news/science-environment-25163113"><em>Indian probe begins journey to Mars</em></a>.</p>
<blockquote style="float: left; width: 35%;"><p>India's mission to Mars has embarked on its 300-day journey to the Red Planet. Early on Sunday the spacecraft fired its main engine for more than 20 minutes, giving it the correct velocity to leave Earth's orbit. It will now cruise for 680m km (422m miles), setting up an encounter with its target on 24 September 2014.</p></blockquote>
<blockquote style="float: left; width: 35%;"><p>India's mission to Mars has embarked on its 300-day journey to the Red Planet.</p>
<p>Early on Sunday the spacecraft fired its main engine for more than 20 minutes, giving it the correct velocity to leave Earth's orbit.</p>
<p>It will now cruise for 680m km (422m miles), setting up an encounter with its target on 24 September 2014.</p></blockquote>
<div style="clear: both;"></div>
<p>Without even reading the content, the version on the right should appear more pleasant. The line breaks should give you a visual cue that each paragraph, while relevant, is not directly related to its neighbours. This is important because it lets you digest the text in smaller chunks which are much easier to comprehend by themselves than one big wall of text.</p>
<p>Breaking up large amounts of text into paragraphs is common practice in modern writing. Unfortunately, this practice doesn't seem to have been adopted by programmers. It's not uncommon to see code with no more than one sequential line break.</p>
<pre class="highlight-javascript javascript">while(index--) {
  digit = uid[index].charCodeAt(0);
  if (digit == 57 /*'9'*/) {
    uid[index] = 'A';
    return uid.join('');
  }
  if (digit == 90  /*'Z'*/) {
    uid[index] = '0';
  } else {
    uid[index] = String.fromCharCode(digit + 1);
    return uid.join('');
  }
}</pre>
<p>The above is an excerpt from the <a href="https://github.com/mozilla/persona">Mozilla Persona</a> source code. It's only 14 lines long, but you need to really engage your brain to read and understand it. Without some sort of paragraph structure, we have no way of knowing which lines are related, so we're forced to digest all 14 lines at once.</p>
<pre class="highlight-javascript javascript">while(index--) {
  digit = uid[index].charCodeAt(0);

  if (digit == 57 /*'9'*/) {
    uid[index] = 'A';
    return uid.join('');
  }

  if (digit == 90  /*'Z'*/) {
    uid[index] = '0';
  } else {
    uid[index] = String.fromCharCode(digit + 1);
    return uid.join('');
  }
}</pre>
<p>With only 2 extra line breaks, the code has been changed from a single 14-line block to three distinct blocks, with the largest being only 6 lines. With this added structure, it's much easier to figure out what each block does: Block #1 sets the value of <code>digit</code>. Block #2 handles the case of <code>digit</code> being 57. Block #3 handles the case of <code>digit</code> being 90, and every other case as well. The difference may be trivial in this example, but applied to larger blocks of code this technique can save hours of time trying to read code.</p>
<p>There aren't any solid rules on when to separate blocks of code. Usually you should trust your gut and split code into blocks of related lines. As a guideline though, I tend to treat the following as separate blocks:</p>
<ul>
<li>Initialization &amp; assignment</li>
<li>Control flow</li>
<li>Data transformations</li>
</ul>
<h2>Line density</h2>
<p>Writers will often use <a href="http://en.wikipedia.org/wiki/Plain_language">plain language</a> to reduce the <em>idea density</em> of their text. This enables readers to quickly skim over text rather than making an effort to understand complex language. Programmers can use similar techniques to reduce what I call the <em>line density</em> of code. Lines become dense when they contain too much logic. A good example is a complex if-statement.</p>
<pre class="highlight-javascript javascript">if (x == 10 || x == 20 &amp;&amp; y == 2 || y == 5)</pre>
<p>In this example, the reader must make a significant effort to determine that there are 3 possible "truth" conditions. The reason this requires so much effort is because we are required to read the line character-by-character until we find the <code>||</code>, which we know separates each condition.</p>
<pre class="highlight-javascript javascript">if (
  x == 10 ||
  x == 20 &amp;&amp; y == 2 ||
  y == 5
)</pre>
<p>By moving each condition onto its own line, the overall line density is reduced, thereby reducing the mental effort required to identify the conditions.</p>
<p>Line density also applies to function calls which take a large number of arguments.</p>
<pre class="highlight-javascript javascript">doSomething(longVariableName, process(anotherVariable), ['array', 'of', 'things'], getSomethingFrom(SOME_CONSTANT))</pre>
<p>This can be made more readable by moving each argument onto a separate line.</p>
<pre class="highlight-javascript javascript">doSomething(
  longVariableName,
  process(anotherVariable),
  ['array', 'of', 'things'],
  getSomethingFrom(SOME_CONSTANT)
)</pre>
<h2>Other factors</h2>
<p><span style="font-size: 21px; line-height: 1.6;">There are plenty of other factors involved in code readability. But as with most things, readability is entirely subjective -- it's important not to confuse it with personal preference.</span></p>
<p>Programming is an interesting mix of engineering and craft. As well as borrowing precision and discipline from engineering, we need to remember to also borrow style and ergonomics from visual design.</p>
