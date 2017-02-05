---
layout: post
title: A faster BBC News
categories:
- BBC News
tags:
- bbc news
- performance
author: Joseph Wynn
status: draft
---

Web performance is something I care deeply about both as a developer whose work affects millions of people around the world, and as a user who often accesses the web on slow & unreliable connections. I have regularly and loudly complained that [the BBC News website is unnecessarily slow](/redefining-the-bcc-news-core-experience/), so when I was given the opportunity to help rebuild one of the most-visited pages of BBC News —the front page— I jumped at the chance.

That was April 2016. Now, nearly a year later, we're ready to begin a phased rollout of the new front page. Starting with a small percentage of users in the UK, we will gradually move everybody to the new front page over the course of several weeks.

## Quick facts about the new front page

* It is lighter and faster than the old one
  * First meaningful paint happens up to 35% sooner on emulated mobile devices and 50% sooner on desktops & laptops.
  * On average, 60% fewer bytes are downloaded (**613KB** -> **383KB**).
  * The new core experience (given to legacy browsers, users without JavaScript, and Opera Mini) renders twice as fast, and downloads 35% fewer bytes (**170KB** -> **114KB**).
  * Performance has been monitored from the beginning, allowing us to address regressions as soon as they happen.
* It is available over HTTPS, and we have plans to redirect insecure traffic to HTTPS in the not-so-distant future.
* The layout is responsive up to 1280 pixels wide (the old layout is responsive up to 1080 pixels).
* All of the page components are built with React and styled with the BBC's ITCSS framework, [Grandstand](https://medium.com/@shaunbent/css-at-bbc-sport-part-1-bab546184e66). The components are rendered by the BBC's React-component-as-an-API-endpoint service. React is _not_ used on the client.
* The development team consists of 5 developers and 1 tester, but we have collaborated with over 60 other developers and testers from all around the BBC to build this page.

## What's next?

We consider this new front page to be an MVP, and we will be changing it considerably over the next several months.<!--more-->

### Performance

While we have managed to improve the performance of the front page considerably, there is still a lot of work to do:

* The first meaningful paint time is still too high. We can improve it by loading the core CSS sooner.
* We still send too many bytes to the client, a lot of which is redundant CSS. I'm optimistic that we can cut the CSS size in half by improving the way we bootstrap styles.
* Style recalculations and layouts take too long on low-powered devices. This still needs some investigation but as a starting point we will aim to reduce DOM node nesting and simplify CSS selectors.
* We are essentially hamstrung by the "white BBC bar" at the top of the page. This bar contains components from other parts of the BBC like Search, Notifications, and BBC ID; all of which load their own CSS and JavaScript assets before any of the BBC News assets. While this loading strategy is unlikely to change, we're hoping to at least make start conversations around delaying loading these products' assets until after the onload event.

### Design enhancements

In order to ship the new front page sooner, we made a lot of compromises with both the UX and editorial teams around the design of the page. Once we're finished with the rollout, we will be improving the visual treatment of story cards (promos) to highlight correspondent stories and feature pieces. The current designs look something like this:

{% responsive_image path: assets/news-front-page-promo-current.png alt: "The plain promo design for the MVP launch" bleed: true %}

And below is one of the proposals for how we might highlight other types of promo:

{% responsive_image path: assets/news-front-page-promo-variation.png alt: "An example of potential visual treatments for special types of promo" bleed: true %}


## Acknowledgements

Firstly, to everybody involved: **thank you**. Rarely have I had the chance to work with so many talented, patient, dedicated, and caring people. From documentation tweaks to requirements gathering, from bug fixes to building entire components; regardless of the size of your contribution, we wouldn't have reached this point without you. So again: thank you, and congratulations. Have a doughnut.

To the design team and editorial staff: thank you for helping us find a balance between perfection and a fast launch.

To the project managers, business analysts, and product owners: I don't think you get enough credit. Thank you for working extraordinarily hard to smooth out all of the bumps in this project, and for providing the development team with a clear path.

And finally, to my team: you are amazing.
