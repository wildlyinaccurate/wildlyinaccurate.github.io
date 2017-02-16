---
layout: post
title: Web development technologies to adopt in 2017
categories:
- Web Development
tags:
- preact
- react
- webpack
- service worker
- performance
author: Joseph Wynn
---

I started 2016 feeling quite overwhelmed by the sheer number of new technologies that were being introduced. This year I feel like many of those technologies have matured, so I have collated a list of the ones that I think deserve your attention. My focus for the last couple of years has been on performance, so I've made an effort to ensure that all of the technologies mentioned are either "performance-friendly" or are directly related to performance.

### Preact — [preactjs.com](https://preactjs.com/)

A fast 3kB alternative to React with the same ES6 API. For projects which use React's other APIs, [preact-compat](https://github.com/developit/preact-compat) exists as a compatibility layer allowing Preact to be a drop-in replacement for React in any project.

As well as being smaller than React, Preact is also much faster. I measured the impact of migrating to Preact in three projects and saw a 3-4x reduction in JavaScript execution times in all of them.

### Webpack — [webpack.js.org](https://webpack.js.org/)

Bundle your scripts, images, styles, assets... I was initially put off Webpack because I thought it did too much. With the help of [Pete Hunt's webpack-howto](https://github.com/petehunt/webpack-howto) I realised that Webpack can be as simple or as complex as you want it to be.

These days I recommend that people use Webpack even for trivial projects because it's easy to set up, the defaults are good, and it opens up a huge number of possibilities for optimising your application.

### offline-plugin — [github.com/NekR/offline-plugin](https://github.com/NekR/offline-plugin)

A highly-configurable Webpack plugin that provides an offline experience for your application using ServiceWorker, with AppCache as a fallback.

If there's one thing on this list that you consider adopting, it should be this. The number of people around the world whose sole means of accessing the Internet on a mobile phone is _increasing_. We can improve their experience on the web immeasurably by utilising technologies like ServiceWorker & AppCache, and this plugin is a ridiculously way to do that.

### Tachyons — [tachyons.io](http://tachyons.io/)

Functional CSS for humans. Tachyons is a mobile-first responsive CSS framework with a focus on accessibility. Its single-purpose class structure is very scalable and practically removes the need to write any custom CSS.

Tachyons has a relatively small footprint, and is extremely modular so you can easily include only what you need.

### Lighthouse — [github.com/GoogleChrome/lighthouse](https://github.com/GoogleChrome/lighthouse)

Built by some of the industry's foremost web performance evangelists, Lighthouse is an automated tool that analyses your web application's performance and provides insights on developer best practices.

While it's useful as a once-in-a-while test, I would recommend running Lighthouse on a regular basis — perhaps part of a daily build. Its insights are broad enough to cover a wide range of issues from accessibility to performance, but specific enough that any issues are easily actionable.

