---
layout: post
title: How we assemble web pages at BBC News
categories:
- BBC News
tags:
- bbc news
author: Joseph Wynn
status: draft
---

At the beginning of 2015, a group of developers and technical architects from around the BBC got together with the goal of designing a system for sharing web page components between teams. This came from an acceptance that most of the BBC's public-facing web products have a similar look & feel, and a desire to improve efficiency through sharing rather than building similar things over and over again.

{% responsive_image path: assets/bbc-promo-similarities.png alt: "Cards or 'promos' from BBC Programmes, BBC Sport, BBC News, and CBBC." %}

In some organisations, technologies are standardised which makes sharing components between teams a trivial task. At the BBC, teams are free to use whichever technologies they like. This means that a component-sharing solution can't be tied to any particular template languages, data structures, or build systems. It can't even be tied to a CSS preprocessor like Sass.

To get around this, we went back to basics and designed a solution that is based on two premises:

1. All web pages are built out of HTML, CSS, and JavaScript.
2. Most web pages have three main parts: the head, the body, and _things that come after the body_.

With that in mind, we designed the WAF, or _Web Application Framework_. It's a surprisingly simple framework, and is built on top of three core principles:

* Components as endpoints
* The envelope contract
* Page composition
<!--more-->

## Components as endpoints

For components to be shared successfully, they need to be easy to distribute, easy to install, and easy to use. For this, we turned to a delivery mechanism that most developers are familiar with: the web.

Every component is available at an HTTP endpoint. How that endpoint is built is unimportant, and varies from team to team. Some teams deploy dedicated applications that render specific components. Others make use of an internal component-as-an-endpoint service. Regardless of the implementation, to integrate successfully into the WAF, every component endpoint must to respond to an HTTP GET request with a rendered component that is ready to be inserted into a page.

## The envelope contract

Having components as endpoints only works if all of the components are returned in the same format. To solve this, we designed the envelope format which imposes a contract on both the component endpoints and the consumers of those endpoints. The contract for component endpoints is this:

* Component endpoints MAY accept parameters which vary the output.
* Component endpoints MUST return a JSON object with the following fields:
  * `head` — an array of strings intended to be inserted into the document `<head>`. Usually stylesheets, metadata, and blocking scripts.
  * `bodyInline` — a string intended to be inserted somewhere in the document `<body>`.
  * `bodyLast` — an array of strings intended to be inserted at the end of the document `<body>`. Usually non-blocking scripts.
* Component endpoints SHOULD atomise the `head` and `bodyLast` values as much as possible.

Here is an example envelope response:

```json
{
    "head": [
        "<style>.some-inline-styles { }</style>",
        "<link rel=\"stylesheet\" href=\"https://m.files.bbci.co.uk/framework.css\">"
    ],
    "bodyInline": "<div class=\"nw-c-top-stories\">[... lots of markup ...]</div>",
    "bodyLast": [
        "<script async defer src=\"https://m.files.bbci.co.uk/modules/bbc-news-front-page/2.0.8/init.js\"></script>"
    ]
}
```

## Page composition

Now that we have web page components available in a standardised format over HTTP, we need a way to assemble the components into a page. To this end, there is a contract for systems that receive envelopes, which we call _page composition_ systems:

* Page composition systems MUST render components in the order they are specified.
* Page composition systems MUST de-duplicate all `head` and `bodyLast` values.
* Page composition systems SHOULD fetch components in parallel.

The de-duplicating aspect of a page composition system is important, because page components may share many of the same dependencies. For example, if many components were built using the Bootstrap CSS framework, they would all return a reference to `bootstrap.css` in their `head`. Rather than render several redundant references to this CSS, the page composition system must ensure that it is rendered only once.

Many BBC teams have implemented their own page composition systems within their existing web applications. BBC News have developed a page composition service called Mozart which provides a simple configuration-driven way to assemble pages while transparently handling the difficult problems like scaling, logging, and monitoring.

## Piecing it all together

This method of assembling web pages is being used successfully in production by several teams at the BBC. The most-shared component is a live-updating stream, initially built for live coverage of sports events on BBC Sport, but now used for live reporting pages on [BBC News](http://www.bbc.co.uk/news/live/uk-england-manchester-38860956), and the [World Service](http://www.bbc.com/persian/live/institutional-38891510). It has also seen some use as a way to display long feeds of content like on the [BBC News topic pages](http://www.bbc.co.uk/news/topics/8abd564a-2b8e-401c-9916-34982cb67b55/womens-rights).
