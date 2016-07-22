---
layout: post
title: 'Redefining the BBC News core experience'
categories:
- BBC News
- Web Development
tags:
- performance
- bbc news
- core experience
- cut the mustard
published: true
author: Joseph Wynn
---

In the beginning of 2012 the BBC Responsive News team wrote about how they provide a "core experience" for users by default, and then progressively enhance the page based on the [cut the mustard test](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard). At the time, this was cutting edge. They were able to build pages which worked on practically any browser without compromising the experience for users on modern browsers. To quote directly from the Responsive News blog:

> The first tier of support we call the core experience. This works on everything. I’ve seen it work on a Nokia E65, a Blackberry OS4, Kindle 1, a HTC Touch 2 running Win Mobile 6.5, a Samsung U900 Soul, a Commodore Vic20, my nan’s slipper and a toaster just selotaped to a TV. Likewise, GoogleBot, text-browsers like Lynx, folks that disable JavaScript and so on are all assured a good level of service.

This technique is still in use today, and is an integral part of the front-end strategy for all modern BBC News pages. In 2012 it allowed the team to provide a fast and lightweight experience for users on low-end devices. 7 HTTP requests totalling 21KB was all it took to load the core experience of the BBC News front page. All users benefited from this initially fast load, with modern browsers progressively enhancing the rest of the page after the content was loaded.

It has been over 4 years since the BBC News core experience was first built, and a lot has changed since then. Today, the core experience consists of 75 HTTP requests totalling over 300KB -- over 15x heavier than the original core experience. With JavaScript disabled and tracking pixels blocked, this can be reduced to 33 requests totalling 125KB -- still over 6x heavier. This is insane. This is not a core experience.

The BBC News team is aware of their website's shortcomings. Back in May 2015 I conducted a huge performance review which I've spoken about extensively both [internally](http://slides.com/wildlyinaccurate/bbc-news-performance-review) and [externally](http://slides.com/wildlyinaccurate/bbc-news-performance) ([video](https://www.youtube.com/watch?v=nE4LTRfcr94)). A _lot_ of work has been done over the last year, and many of the issues mentioned in those slides have already been addressed. Despite this, the elephant in the room is still the core experience.

That's why when BBC News ran an internal _hack day_ (where people can form teams to work on whatever they like) I took the opportunity to totally redefine the BBC News core experience.

## Why have a core experience?

If you're not already convinced that having a core experience is a good idea, I'll attempt to sell it to you now.

Of the 3.6 billion Internet users today, over 2 billion (65%) are accessing the web from developing countries. This percentage will continue to increase over the coming years, as Intenet usage growth in developing countries is over 100x more than the rest of the world. Yes, you read that right -- 100x! In India alone, over 108 million new users accessed the Internet for the first time in the last year.

Despite huge Internet growth in developing countries, device capabilities and connection speeds are not improving. A typical smartphone sold new in India in 2016 has 512MB of RAM, or about one sixth of a typical 2016 smartphone sold in developed countries. Nearly 70% of users in developing countries rely on cellular data to access the Internet. What's interesting is that while this number is much lower in developed countries (10-20%), this number has actually been _increasing_ -not decreasing- over the last few years.

So what does all of this have to do with a core experience? If the majority of your users access the Internet on a mobile connection, then (hopefully) the last thing you want to do is send them bytes they don't need. Not only can this be costly for your users (it would take 17 hours of minimum wage work in India to purchase 500MB of mobile data), it can also be costly for your business. At BBC News, the difference between a page loading in 4 seconds versus the same page loading in 8 seconds correlates to a 30% increase in users abandoning the page.

Providing a core experience is about being able to reach users all around the world, regardless of connection speed and device capabilities. It's about thinking beyond the USA & Europe, and welcoming the other 65% of the Internet to your website.

## The definition

I don't know if there is an official definition of _core experience_ anywhere, but to me it means delivering a page with these five things, in order of importance:

 1. The page content.
 2. The markup required to make the page accessible.
 3. Minimal styling to make the content easily readable -- grids, typography, etc.
 4. Minimal styling to make the page recognisable as yours -- branding, colours.
 5. The means to enhance the page where appropriate.

The way this has been achieved so far at the BBC has been to create a small `core.css` stylesheet containing just the styles for points 3 and 4. Then, provided the browser cuts the mustard, some JavaScript picks up point 5 and inserts an `enhanced.css` stylesheet into the page, containing the rest of the styling. This same JavaScript also downloads and initialises other JavaScript enhancements, like live updates and localisation services.

## The problem with the BBC News core experience

Using CTM to provide an enhanced experience is great from a web developer's point of view: browsers which use `enhanced.css` can use modern (in browser terms) standards like CSS3 without worry, Likewise, modern JavaScript can be used without the need for polyfills or compatability libraries. But there's a problem with this approach: the user has no say in which experience they get. 
