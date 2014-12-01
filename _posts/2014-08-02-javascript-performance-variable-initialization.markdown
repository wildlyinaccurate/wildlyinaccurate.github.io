---
layout: post
title: 'JavaScript Performance: Variable Initialization'
date: 2014-08-02 00:10:46.000000000 +01:00
categories:
- JavaScript
tags:
- javascript
- performance
- v8
status: publish
type: post
published: true
author: Joseph Wynn
---

Initializing variables properly in JavaScript can have significant performance benefits. This can be shown with a simple synthetic benchmark.

### notype.js

<pre class="highlight-js">var x = null;

for (var i = 0; i &lt; 1e8; i++) {
    x = 1 + x;
}</pre>

### withtype.js

<pre class="highlight-js">var x = 0;

for (var i = 0; i &lt; 1e8; i++) {
    x = 1 + x;
}</pre>

### Benchmark Results

<pre class="no-highlight">$ time node notype.js
node notype.js  **0.30s** user 0.01s system 100% cpu 0.301 total

$ time node withtype.js
node withtype.js  **0.10s** user 0.00s system 99% cpu 0.109 total</pre>

This particular benchmark may be trivial, but it demonstrates an important point. In `notype.js`, `x` is initialized as `null`. This makes it impossible for V8 to optimize the arithmetic within the loop, since the type of `x` must be inferred during the first arithmetic operation. By contrast, the compiler can optimize `withtype.js` because `x` is known to be a number.

Running these scripts again with V8's profiler enabled, we can gain some additional insight into what's going on under the hood.

### notype.js

<pre class="no-highlight"> [JavaScript]:
   ticks  total  nonlib   name
    181   63.3%   71.8%  LazyCompile: * /home/joseph/dev/jsperf/var_init_value/notype.js:1
     68   23.8%   27.0%  Stub: BinaryOpStub_ADD_Alloc_SMI
      1    0.3%    0.4%  LazyCompile: ~PropertyDescriptor native v8natives.js:482
      1    0.3%    0.4%  KeyedLoadIC: A keyed load IC from the snapshot
      1    0.3%    0.4%  CallInitialize: args_count: 3</pre>

### withtype.js

<pre class="no-highlight"> [JavaScript]:
   ticks  total  nonlib   name
     72   66.7%   98.6%  LazyCompile: * /home/joseph/dev/jsperf/var_init_value/withtype.js:1
      1    0.9%    1.4%  LazyCompile: RegExpConstructor native regexp.js:86</pre>

The profiler doesn't give us the full picture here, but we can see that `notype.js` is spending a fair amount of time in `BinaryOpStub_ADD_Alloc_SMI`, which V8 uses to create SMI (small integer) values.

It's possible to dig into this even further by having V8 output the Hydrogen code (the intermediate language which V8 uses to represent the JavaScript code's abstract syntax tree), or _even_ further by having V8 output the final assembly code. However, both of these things are outside the scope of this post. (If you're _really_ interested, I've posted the output [on GitHub](https://gist.github.com/wildlyinaccurate/423294822c2729743490).)

If this sort of thing interests you, you might enjoy reading Thorsten Lorenz's collection of [V8 performance resources](https://github.com/thlorenz/v8-perf) or Petka Antonov's [V8 optimization killers](https://github.com/petkaantonov/bluebird/wiki/Optimization-killers).