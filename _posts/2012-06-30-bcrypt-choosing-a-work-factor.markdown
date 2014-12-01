---
layout: post
title: 'Bcrypt: Choosing a Work Factor'
date: 2012-06-30 19:42:31.000000000 +01:00
categories:
- Security
- Web Development
tags:
- bcrypt
- brute-force
- hashing
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>Bcrypt is a Blowfish-based hashing algorithm which is commonly used for password hashing because of its potentially expensive key setup phase. A Bcrypt hash has the following structure:</p>
<pre class="no-highlight">$2a$(2 chars work)$(22 chars salt)(31 chars hash)</pre>
<p>The reason that the key setup phase can be potentially expensive is because it is run <code>2<sup>work</sup></code> times. As password hashing is usually associated with common tasks like logging a user into a system, it's important to find the right balance between security and performance. Using a high work factor makes it incredibly difficult to execute a brute-force attack, but can put unnecessary load on the system.</p>
<p>Using <a href="https://gist.github.com/1053158/">Marco Arment's PHP Bcrypt class</a>, I performed some benchmarks to determine how long it takes to hash a string with various work factors:<!--more--></p>
<h3>Benchmarks</h3>
<p><strong>Desktop Machine, Intel i3-2120 (Quad Core, 3.30GHz)</strong></p>
<pre class="no-highlight">Work	Time (Seconds)
4	0.0013326406478882
5	0.0024385929107666
6	0.0046159029006958
7	0.0089994072914124
8	0.018425142765045
9	0.035568559169769
10	0.070761203765869
11	0.14275025129318
12	0.28672399520874
13	0.56773639917374
14	1.1397068500519
15	2.2705371022224
16	4.5342264413834
17	9.0786491513252
18	18.10820235014
19	36.225910997391
20	72.565172195435</pre>
<p><strong>Linode Xen Instance (Shared Intel Xeon)</strong></p>
<pre class="no-highlight">Work	Time (Seconds)
4	0.0054517030715942
5	0.0034224390983582
6	0.0065383553504944
7	0.012924599647522
8	0.025654697418213
9	0.050982797145844
10	0.10348515510559
11	0.24127880334854
12	0.5001261472702
13	0.96253979206085
14	1.8935391068459
15	3.821101295948
16	7.3601801991463
17	14.522540104389
18	30.156531906128
19	58.399033403397
20	117.1653290987</pre>
<p>Marco's default work factor of 8 looks like a good place to start, taking 0.2 seconds on both the desktop and Xen instance. Personally I use a work factor of 12, which is fast enough to not be noticed and will (hopefully) still be strong in a few years. With a work factor of 14 you can start to see what kind of difference computational power makes - the desktop machine generates the hash nearly twice as fast as the Xen instance.</p>
<p>I don't believe that there is a "correct" work factor; it depends on how strong you want your hashes to be and how much computational power you want to reserve for the hashing process. Keep in mind that as time goes by and you want to increase your hash strength, you can easily increase the work factor and re-hash each user's password on their next successful login. This also applies if the password hashing procedure is generating too much load; you can reduce the work factor.</p>
