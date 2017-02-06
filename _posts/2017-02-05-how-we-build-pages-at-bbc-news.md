---
layout: post
title: How we build pages at BBC News
categories:
- BBC News
tags:
- bbc news
author: Joseph Wynn
status: draft
---

At the beginning of 2015, a group of developers and technical architects from around the BBC got together with the aim of designing a system for sharing web page components between teams. This came from an acceptance that most of the BBC's public-facing web products have a similar look & feel, and a desire to improve efficiency through sharing rather than building similar things over and over again.

{% responsive_image path: assets/bbc-promo-similarities.png alt: "Cards or 'promos' from BBC Programmes, BBC Sport, BBC News, and CBBC." %}

The solution we came up with is very simple. It is built on two simple premises:

1. All web pages are built out of HTML, CSS and JavaScript.
2. Most web pages have three main parts: the head, the body, and _things that come after the body_.

Because the solution is so simple, we never gave it a name. Informally, it is known as "the WAF", or _Web Application Framework_. Or _Web Assembly Framework_. Sometimes the "F" means _Foundation_. The name doesn't matter; what matters are the core principles:

* Components as endpoints
* The envelope contract
* Page composition

## Components as endpoints

If we're going to share components, they need to be easy to distribute and easy to use. For this, we settled on a mechanism that all web developers are familiar with: the web.

Every component is available at an HTTP endpoint. How that endpoint is managed is unimportant, and varies from team to team. Some teams deploy small dedicated applications to render components. Others make use of a componetn-as-an-endpoint service & framework developed by the BBC Sport team.

## The envelope contract

Building a page out of many different components is only easy if all of the components are the same format. For this, we designed the envelope contract. The contract for component endpoints is this:

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

Now that we have web page components available as HTTP endpoints, all returning a standard format, we need a way to assemble the components into a page. For this, there is also a contract for systems which _receive_ envelopes, which we call _page composition_:

* Page composition systems MUST render components in the order they are specified.
* Page composition systems MUST de-duplicate all `head` and `bodyLast` values.
* Page composition systems SHOULD fetch components in parallel.

The de-duplicating aspect of a page composition system is important, because page components may share many of the same dependencies. For example, if many components were built using the Bootstrap CSS framework, they would all return a reference to `bootstrap.css` in their `head`. Rather than render several redundant references to this CSS, the page composition system must ensure that it is rendered only once.

Many BBC teams have implemented their own page composition systems within their existing web applications. BBC News have developed a page composition service called Mozart which provides a simple configuration-driven way to build pages while transparently handling the difficult problems like scaling, logging, and monitoring.
