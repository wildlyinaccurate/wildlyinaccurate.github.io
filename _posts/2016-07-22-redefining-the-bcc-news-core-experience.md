---
layout: post
title: 'Redefining the BBC News core experience'
categories:
- BBC News
tags:
- performance
- bbc news
- core experience
- cut the mustard
published: true
author: Joseph Wynn
---

In the beginning of 2012 the BBC Responsive News team wrote about how they provide a "core experience" for users by default, and then progressively enhance the page if the browser [cuts the mustard](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard). At the time, this was cutting edge. They were able to build pages which worked on practically any browser without compromising the experience for users on modern browsers. To quote directly from the Responsive News blog:

> The first tier of support we call the core experience. This works on everything. I’ve seen it work on a Nokia E65, a Blackberry OS4, Kindle 1, a HTC Touch 2 running Win Mobile 6.5, a Samsung U900 Soul, a Commodore Vic20, my nan’s slipper and a toaster just sellotaped to a TV. Likewise, GoogleBot, text-browsers like Lynx, folks that disable JavaScript and so on are all assured a good level of service.

This technique is still in use today, and is an integral part of the front-end strategy for all modern BBC News pages. In 2012 it allowed the team to provide a fast and lightweight experience for users on low-end devices. 7 HTTP requests totalling 21KB was all it took to load the core experience of the BBC News front page. All users benefited from this initially fast load, with modern browsers progressively enhancing the rest of the page after the content was loaded.

It has been over 4 years since the BBC News core experience was first built, and a lot has changed since then. Today, the core experience consists of 75 HTTP requests totalling over 300KB -- over 15x heavier than the original core experience. With JavaScript disabled and tracking pixels blocked, this can be reduced to 33 requests totalling 125KB -- still over 6x heavier. This is insane. This is not a core experience.

The BBC News team is aware of their website's shortcomings. Back in May 2015 I conducted a huge performance review which I've spoken about extensively both [internally](http://slides.com/wildlyinaccurate/bbc-news-performance-review) and [externally](http://slides.com/wildlyinaccurate/bbc-news-performance) ([video](https://www.youtube.com/watch?v=nE4LTRfcr94)). A _lot_ of work has been done over the last year, and many of the issues mentioned in those slides have already been addressed. Despite this, the elephant in the room is still the core experience.

That's why when BBC News ran an internal hack day (where people can form teams to work on whatever they like) I took the opportunity to totally redefine the BBC News core experience.<!--more-->

## Why have a core experience?

If you're not already convinced that having a core experience is a good idea, I'll attempt to sell it to you now.

Of the 3.6 billion Internet users today, over 2 billion (65%) are accessing the web from developing countries. This percentage will continue to increase over the coming years, as Internet usage in developing countries is growing over 100x faster than the rest of the world. Yes, you read that right -- 100x! In India alone, over 108 million people accessed the Internet for the first time in the last year. That was a 30% increase over the year before.

{% responsive_image path: assets/internet-growth-in-india.png alt: "Internet growth in India is accelerating at an enormous rate" %}

Despite huge Internet growth in developing countries, device capabilities and connection speeds are not improving. A typical smartphone sold in India in 2016 has 512MB of RAM, or about one sixth of a typical 2016 smartphone sold in developed countries. Fast connections are still a precious commodity, with nearly 70% of users in developing countries relying on cellular data to access the Internet. What's interesting is that while this number is much lower in developed countries (10-20%), it has actually been _increasing_ --not decreasing-- over the last few years.

So what does all of this have to do with a core experience?

If the majority of your users access the Internet on a mobile connection, then (hopefully) the last thing you want to do is send them bytes they don't need. Not only can this be costly for your users (it takes 17 hours of minimum wage work in India to purchase 500MB of mobile data), it can also be costly for your business. At BBC News, the difference between a page loading in 4 seconds versus the same page loading in 8 seconds correlates to a 30% increase in users abandoning the page. This is a big deal for content providers like the BBC, and an even bigger deal for online stores.

Providing a core experience is about being able to reach users all around the world, regardless of connection speed and device capabilities. It's about thinking beyond the USA & Europe, and welcoming the other 65% of the Internet to your website.

## The definition of a core experience

A core experience should be made up of these five things, in order of importance:

 1. The page content.
 2. The markup required to make the page accessible.
 3. Minimal styling to make the content easily readable -- grids, typography, etc.
 4. Minimal styling to brand the page -- logo, colours.
 5. The means to enhance the page where appropriate.

A core experience should be _just_ these things. Everything else is an enhancement.

The way this has been achieved so far at the BBC has been to create a small `core.css` stylesheet containing just the styles for points 3 and 4. Then, provided the browser cuts the mustard, some JavaScript inserts an `enhanced.css` stylesheet into the page which contains the rest of the styling. This JavaScript is also responsible for downloading and initialising other JavaScript enhancements, like live updates and localisation services.

## The problem with the BBC News core experience

Cutting the mustard to provide an enhanced experience is great from a web developer's point of view: browsers that use `enhanced.css` can use modern (in browser terms) standards like CSS3. Likewise, modern JavaScript can be used without the need for polyfills or compatibility libraries. But there's a problem with this approach: the user has no say in which experience they get.

The fact that a user has a modern browser does not mean that they have a fast or reliable connection. Providing a core experience is useless if users are going to be forced onto the enhanced experience anyway. Loading the enhanced BBC News front page on a mobile device will cost about 500KB. Opening an article page from there will cost another 370KB. That's a cost of nearly 1MB of data (or 20 minutes of minimum wage work) just to read a single article.

{% responsive_image path: assets/bbc-news-core.png alt: "The BBC News core experience on a wide screen" %}

As well as being unnecessarily heavy, the BBC News core experience was designed with small screens in mind. The content is forced into a single column layout, and the width of the primary image is hard-coded to 200px. It looks fine on low resolution smartphones and feature phones, but on anything larger it starts to look stretched and at the same time somewhat empty.

## Starting from scratch

Earlier this week, I started thinking about how I would approach the core experience for BBC News if I was given the opportunity to build it from scratch.

What I came up with was a hand-rolled CSS framework using Sass mixins from [Bootstrap v4](https://github.com/twbs/bootstrap/tree/v4-dev), which allowed me to build a page with very minimal markup. The results were promising:

 * A 7KB HTML document containing all the core content and inlined styles -- 80% smaller than the current 36KB core experience.
 * 2 HTTP requests totalling 27KB -- 73 fewer requests and 90% fewer bytes.
 * A fully responsive layout which works at all device widths.
 * Responsive images for browsers which support `srcset`, with fallbacks to a sensibly-sized `src`.
 * 100ms first paint time -- 150ms faster (60%) than the current core experience.
 * 460ms first paint time -- 440ms faster (50%).
 * A much better CPU profile.

{% responsive_image path: assets/lightweight-cpu-profile.png alt: "The CPU profile of the lightweight prototype" %}

{% responsive_image path: assets/bbc-news-core-cpu-profile.png alt: "The CPU profile of the current BBC News core experience" %}

Obviously I've cheated a bit. There is no white "BBC bar" at the top (which accounts for much of the page weight on the core experience). There is no site navigation, and a small amount of core content is missing. However, the remaining core content can be added in a couple of bytes, and in my opinion the other features should not be part of the core experience anyway.

Here is the finished product on a wide screen:

{% responsive_image path: assets/redefining-core-prototype.png alt: "The lightweight core experience prototype" %}

As well as creating a truly lightweight core experience, I also wanted to think about how we can put people back in control of their own web experience. We can give people a core experience when we think they need it --for example by detecting screen width or connection speed-- and also them give them the controls to progressively enhance the page themselves.

I've started to explore these ideas by implementing two controls:

 * A button which (lazily) loads the remaining images on the page. This requires basic JavaScript support, so can be used by most users.
 * Buttons to prefetch article content. This requires a browser with Service Worker support.

I think there's certainly more to explore in this area, especially around minimising the amount of interaction required to receive the optimal or desired experience.

The code for this prototype is [on GitHub](https://github.com/wildlyinaccurate/news-core-experience), and a demo is available at [https://wildlyinaccurate.com/news-core-experience/](https://wildlyinaccurate.com/news-core-experience/).

## Why isn't the core experience already like this?

When I presented this prototype to the BBC News technical teams, the responses were mostly along the lines of _"why isn't the core experience already like that?"_. I may be trivialising it slightly, but I think that the answer to that question is pretty simple: feature creep, and a lack of monitoring.

I cannot stress enough how important monitoring is for performance. The BBC's lack of performance monitoring is probably one of the biggest reasons behind the deterioration of the BBC News core experience. Good monitoring enables realistic performance budgets, which in turn enables automated warnings when performance budgets are overspent.

Today the BBC uses [SpeedCurve](https://speedcurve.com/) to run over 22,000 performance tests each month. These tests notify us when we approach our performance budgets, and allow us to address problems before they become a serious concern.

Feature creep is a harder problem to address. At the BBC, it has mostly come in the form of the "white BBC bar" at the top of every page. This is an area of the page which used to have a very good core experience, but over the last few years it has expanded to include features from internal products around the BBC. These include:

#### BBC iD

The ID service allows you to sign in so that you can do things like post comments and receive notifications. It adds 13 HTTP requests to the page --8 of which are scripts-- totalling 25KB.

{% responsive_image path: assets/bbc-id.png alt: "The BBC iD button" %}

#### Notifications

The notifications service is the little bell icon at the top. When you're signed in, it will notify you when your favourite TV shows and radio programmes are updated. Notifications adds 7 HTTP requests to the page, with a weight of 37KB. 2 of these requests are scripts, and 4 are individual SVG icons.

Clicking the icon results in another 2 requests being made, including a 47KB font.

{% responsive_image path: assets/bbc-notifications.png alt: "The BBC Notifications popover" %}

#### Search

Search is the simple text input at the top-right of the page. Only, it's not simple. When you start to type into the input, you're presented with a lookahead-esque search interface. The BBC Search interface adds 4 HTTP requests to the page, totalling 14KB.

Beginning to type into the search input triggers `app.min.js` to be loaded in the page, weighing in at a hefty 86KB -- or 320KB without compression! Furthermore, two HTTP requests at 4KB each are made on the (debounced) `onchange` event. Simply typing the word _"bears"_ resulted in my browser making 10 additional requests totalling 43KB.

{% responsive_image path: assets/bbc-search.png alt: "The BBC Search interface" %}

Not a single one of these products provides a core experience. And, unfortunately for the BBC News development teams, including these products in the page is not optional.

Every website will have its own unique set of challenges around feature creep. My advice is to have good monitoring, and take your performance budgets seriously. In short:

 * **Don't** increase the budget to accommodate new features.
 * **Do** compromise by removing or optimising old features.

## Where to from here?

I want the BBC to start taking the core experience seriously again. The prototype that I have built serves as a reminder that web pages _can_ be fast, but only when the emphasis is on the content.

BBC World Service is expanding to reach a wider audience by 2020, and most of the users in that audience will come from developing countries. This is a fantastic opportunity to reinvent the BBC's web experience and tailor it for the users we _have_ (people using underpowered phones on mobile connections), rather than the users we _want_ (people using Macbooks on cable connections).

With HTTPS Everywhere being [rolled out across the BBC](http://www.bbc.co.uk/blogs/internet/entries/f6f50d1f-a879-4999-bc6d-6634a71e2e60) later this year, the BBC's web teams will have the ability to create some great experiences using service workers. This opens up a whole new set of opportunities around progressive enhancement and performance.
