---
layout: post
title: Introducing a faster BBC News front page
categories:
- BBC News
- Performance
tags:
- bbc news
- performance
author: Joseph Wynn
published: true
---

Web performance is something I care deeply about both as a developer whose work affects millions of people around the world, and as a user who often accesses the web on slow & unreliable connections. I have regularly and loudly complained that [the BBC News website is unnecessarily slow](/redefining-the-bcc-news-core-experience/), so when I was given the opportunity to help rebuild one of the most visited pages of BBC News—the front page—I jumped at the chance.

That was April 2016. Now, a whole year later, we're ready to begin a phased rollout of the new front page. Starting with a small percentage of users in the UK, we will gradually move everybody to the new front page over the course of several weeks. (Update: as of June 2017, the new front page is rolled out to all users).

## Quick facts about the new front page

* It is lighter and faster than the old one:
  * First meaningful paint happens up to **50% sooner** on mobile devices<sup><a href="#footnotes">[1]</a></sup>.
  * Page enhancements like lazy-loaded images load **150% faster** on mobile, and **70% faster** on desktop.
  * The total bytes downloaded is **50% less** on mobile and **75% less** on desktop.
  * CPU busy time has been reduced by **30%** on mobile and by **50%** on desktop.
  * Performance monitoring has been automated with [SpeedCurve](https://speedcurve.com/) from the beginning of the project.<!--more-->
* It is available over HTTPS, and we have plans to redirect insecure traffic to HTTPS in the not-so-distant future.
* The page is built from React components that are styled with the BBC's CSS framework, [Grandstand](https://github.com/bbc/grandstand).
* Each component is a horizontal "slice" of the page that fetches its own data. This makes it easy for us to reuse slices on any page.
* The React components are individually rendered by the BBC's React-component-as-an-API-endpoint service and assembled into a page by our [page-assembly-as-a-service system](/how-we-assemble-web-pages-at-bbc-news/).
* React is only used on the server. We do not load it in the browser<sup><a href="#footnotes">[2]</a></sup>.
* The development team consists of 5 developers and 1 tester, but we have collaborated with over 60 other developers and testers from all around the BBC to build this page.

## What's next?

The version of the front page we're rolling out is an MVP, a _phase one_. We will be changing it considerably over the next several months. Here's an idea of what you can expect to see:

### Performance improvements

While we have managed to improve the performance of the front page considerably, there is still a lot of work to do:

* The first meaningful paint time is still too high. We can improve it by loading the core CSS sooner.
* We still send too many bytes to the client. A good portion of this is from inline styles that are only used on IE8. (Update: We already have a pull request open to drop the IE8-only styles, which should reduce the amount of inline styles by about a third).
* Style recalculations and layouts take too long on low-powered devices. This still needs some investigation.
* We are essentially hamstrung by the "white BBC bar" at the top of the page. This bar contains components from other parts of the BBC like Search, Notifications, and BBC ID. All of these components load their own blocking CSS & JavaScript before any of the BBC News assets. While this is unlikely to change in the short term, we're hoping to work with the teams that own these components to reduce their impact.

### Design enhancements

In order to ship the new front page sooner, we made a lot of compromises with both the UX and editorial teams around the design of the page. Once we're finished with the rollout, we will be improving the visual treatment of story cards (promos) to highlight correspondent stories and feature pieces. The current designs look something like this:

{% responsive_image path: assets/news-front-page-promo-current.png alt: "The plain promo design for the MVP launch" bleed: true %}

And below is one of the proposals for how we might display other types of promo:

{% responsive_image path: assets/news-front-page-promo-variation.png alt: "An example of potential visual treatments for special types of promo" bleed: true %}

### React in the browser

We decided early on in the project that using React in the browser was overkill for a page that is predominantly static text and images. The performance impact of bundling so much JavaScript and executing it in the browser is also unacceptably high: Even making use of server-side rendering, emulated mobile devices spend nearly 4 times as long executing scripts and performing layouts & paints when React was run on the page.

{% responsive_image path: assets/news-front-page-timeline-static.png alt: "A timeline of the server side rendered page without React in the browser" %}

{% responsive_image path: assets/news-front-page-timeline-react.png alt: "A timeline showing the impact of running React in the browser" %}

Our current approach to running JavaScript in the browser is to build a good ol' fashioned bundle, completely separate from the React components. However, we realise that this isn't going to scale for very long, and that eventually we will have to find a way to run our React components in the browser without impacting the user experience. Solutions that we're looking into include:

* Using [Preact](https://preactjs.com/) in place of React.
* Converting our components to [stateless functional components](https://preactjs.com/guide/types-of-components#stateless-functional-components) where possible to reduce their size.
* Smarter [code splitting](https://webpack.js.org/guides/code-splitting/) so that we can load non-essential code on-demand.

## Acknowledgements

Firstly, to everybody involved: **thank you**. Rarely have I had the chance to work with so many talented, patient, dedicated, and caring people. From documentation tweaks to requirements gathering, from bug fixes to building entire components; regardless of the size of your contribution, we wouldn't have reached this point without you. So again: thank you, and congratulations on reaching this milestone.

To the design team and editorial staff: thank you for helping us find a balance between perfection and a fast launch.

To the project managers, business analysts, and product owners: I don't think you get enough credit. Thank you for working extraordinarily hard to smooth out all of the bumps in this project, and for providing the development team with a clear path.

And finally, to my team: You are amazing. I'm so proud of what we've built together. On a more personal level, you've made coming into work feel like coming home to a second family, and I'm eternally grateful for that. The donuts are on me 💜.

<hr>

### Footnotes

1. Mobile device testing was performed using the "Mobile - Emerging Markets" setting on [WebPagetest](https://www.webpagetest.org/) (_Chrome Beta on a Motorola G (gen 4) tested from Dulles, Virginia on a 400 Kbps 3G connection with 400ms of latency_).
2. BBC News does not load React in the browser, but some other page components (like the BBC-wide search bar in the top-right) do load React.
