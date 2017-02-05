---
layout: post
title: A faster BBC News
categories:
- BBC News
tags:
- bbc news
- performance
author: Joseph Wynn
draft: true
---

Web performance is something I care deeply about both as a developer whose work affects millions of people around the world, and as a user who often accesses the web on slow & unreliable connections. I have regularly and loudly complained that [the BBC News website is unnecessarily slow](/redefining-the-bcc-news-core-experience/), so when I was given the opportunity to help rebuild the front page of BBC News, I jumped at the chance.

That was April 2016. Now nearly a year later, we're about to begin a phased rollout of the new front page. Starting with a small percentage of users in the UK, we will gradually move everybody to the new front page over the course of several weeks.

## Quick facts about the new front page

* It is lighter and faster than the old one
  * First meaningful paint happens up to 35% sooner on emulated mobile devices and 50% sooner on desktops & laptops.
  * On average, 60% fewer bytes are downloaded (**613KB** -> **383KB**).
  * The new core experience (given to legacy browsers, users without JavaScript, and Opera Mini) renders twice as fast, and downloads 35% fewer bytes (**170KB** -> **114KB**).
* It is available over HTTPS, and we have plans to redirect insecure traffic to HTTPS in the not-so-distant future.
* The layout is responsive up to 1280 pixels wide (the old layout is responsive up to 1080 pixels).
* All of the page components are built with React and styled with the BBC's ITCSS framework, [Grandstand](https://medium.com/@shaunbent/css-at-bbc-sport-part-1-bab546184e66). The components are rendered by the BBC's React-component-as-an-API-endpoint service. React is _not_ used on the client.
* The development team consists of 5 developers and 1 tester, but we have collaborated with over 60 other developers and testers from all around the BBC to build this page.

## What's next?

We consider this new front page to be an MVP, and we will be changing it considerably over the next several months.

### Performance

While we have managed to improve the performance of the front page considerably, there is still a lot of work to do. My goals for the next few months are:

* Reduce start render times by loading core CSS sooner.
* Cut the amount of CSS we send to the user in half.
* Reduce DOM nesting and remove unnecessary nodes.

Unfortunately, the performance of all BBC News pages is hamstrung by the "white BBC bar" at the top of the page. This bar contains components from other parts of the BBC such as Search, Notifications, and BBC ID; all of which ship their own CSS and JavaScript assets before any of the BBC News assets.

### Design enhancements

<!--more-->

## Acknowledgements

I'm not going to name everybody who has had a hand in this project, but I would like to acknowledge a few things.

First, to everybody involved: **thank you**. Rarely have I had the chance to work with so many talented, patient, dedicated, and caring people. Regardless or how big or small you perceive your role in this project, we wouldn't have reached this point without you. So again, **thank you**, and **congratulations**. Have a doughnut.
