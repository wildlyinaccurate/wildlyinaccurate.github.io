---
layout: post
title: 'Web performance teardown: TradeMe'
categories:
- Performance
- Web Development
tags:
- javascript
- performance
- teardown
author: Joseph Wynn
published: false
---

Most of the English-speaking world has Amazon and eBay. In New Zealand we have TradeMe - an online auction & classified advert website where Kiwis go to buy & sell general items, cars, and property. If the numbers are to be believed, then pretty much every Kiwi has a TradeMe account. I don't think it's an understatement to say that TradeMe is an itegral part of modern New Zealand culture.

Back in 2016, [TradeMe announced](https://investors.trademe.co.nz/media/75789/5-F16-Investor-presentation.pdf) that it was working on a new "smartphone-optimised" responsive website that will eventually also replace the desktop website. Then halfway through 2018, they announced that the new responsive website was being rolled out to real users.

Being the ever-curious developer, I wanted to give the new TradeMe website a try. After a couple of weeks using the new website on my phone (a Nokia 7 Plus), I became frustrated with how much time I spent staring at a loading spinner, and how sluggish the UI interactions were. So I went back to the old website.

{% responsive_image path: assets/trademe-preview-loading.jpg alt: "The loading screen for the new TradeMe website" %}

This bothered me, because I know that the other TradeMe experiences are fast. Why should this new website be so slow? I wanted to dig deeper, so I've taken the opportunity to conduct a detailed performance teardown.<!--more-->

## Step 0: Defining the test parameters

One of the first things I like to do when I'm assessing the performance of a website is set a benchmark -- what do users _expect_ from this website? In most cases it makes sense to use a competing website as the benchmark. When we were [improving the performance of BBC News](/introducing-a-faster-bbc-news-front-page/), we used The Guardian and Financial Times as our benchmark because they are two of the fastest websites in the industry. However, it isn't fair to use eBay or Amazon as a benchmark for TradeMe because they are both multi-billion dollar companies with thousands of developers. Instead, I'm using the much older (but much faster) TradeMe Touch website as a benchmark.

The next thing I like to do is find some performance metrics that are representative of the user experience. Given that TradeMe is mostly used by buyers (as opposed to sellers), I focused on visual completeness (_when can I see the thing I'm trying to buy?_) and interactivity (_when can I scroll and place a bid?_). Both of these things are very easy to measure with [WebPageTest](https://www.webpagetest.org/):

- I measure visual completeness by looking for the point at which the primary image is loaded using [hero element times](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/Metrics/HeroElements.md) (which are currently hidden behind the [heroElementTimes flag](https://www.webpagetest.org/?heroElementTimes=1)).
- I measure interactivity by using [WebPageTest's Time to Interactive metric](https://github.com/WPO-Foundation/webpagetest/blob/master/docs/Metrics/TimeToInteractive.md), which is calculated as the point when the main thread has not been blocked for 5 seconds.

The final parameter is the test configuration. I wanted to emulate the performance of a mid-range smartphone on a mobile data connection, so for all of these tests I used the following settings in WebPageTest:

- **Test Location:** Sydney, Australia - EC2
- **Browser:** Chrome
- **Connection:** 3G (1.6 Mbps/768 Kbps 300ms RTT)
- **Emulate Mobile Browser:** iPhone 6/7/8
- **CPU Throttling:** 2.6 (specified using the [throttle_cpu flag](https://www.webpagetest.org/?throttle_cpu=2.6))

## Step 1: The benchmark

First up is the old TradeMe Touch website. In the screenshot below, you can see two metrics are highlighted: First Interactive and Largest Image Render. The page is considered interactive at **7.2 seconds**, and the primary image is rendered at **14.9 seconds**. The interactive time is not bad for a mid-range mobile device, but having to wait nearly 15 seconds to see the primary content is not something that most users will be happy about. I know I said that I wouldn't compare TradeMe to its better-resourced international competitors, but just for reference: a similar page on eBay renders the primary image at **5.3 seconds**.

{% responsive_image path: assets/trademe-touch-iphone-6.png alt: "A waterfall chart showing the timeline of a TradeMe Touch listing page" %}

Now let's see how the new website performs: interactive at **11.6 seconds**, and the primary image is rendered at **30.4 seconds**. No wonder I felt frustrated using this new website! On the bright side, there's plenty of good performance lessons we can learn from this teardown. So let's dig a bit deeper.

{% responsive_image path: assets/trademe-preview-iphone-6.png alt: "A waterfall chart showing the timeline of a TradeMe Preview listing page" %}

<small>(These screenshots are from the [SpeedCurve](https://speedcurve.com/) test detail page, which has an awesome timeline visualisation).</small>

## Step 2: Identifying performance bottlenecks

### Main thread activity

The first thing that draws my eye is this 2-second slice where the main thread is busy evaluating JavaScript. During these 2 seconds, the browser is doing nothing else. No layouts, no painting, not even any network requests.

{% responsive_image path: assets/trademe-preview-iphone-6-main-thread.png alt: "JavaScript is blocking the main thread for 2 seconds at this point in the timeline" %}

When I open the network view, it's obvious what's causing this: the browser is evaluating the 716KB of JavaScript that it just downloaded. This number is the bytes that were sent over the network, and doesn't represent the true cost of this JavaScript. Once uncompressed, these JavaScript files weigh in at over 2.7MB.  (Tip: in the Network tab of Firefox DevTools, you can choose to show both the "Transferred" and "Size" columns so that you can see both the bytes over the wire and the raw uncompressed resource size).

{% responsive_image path: assets/trademe-preview-iphone-6-network-js.png alt: "Large JavaScript requests in the network view" %}

This 2 second period is just the tip of the iceberg. By the time the page has finished loading, over 2.2MB of JavaScript has been downloaded. This expands to more than 5.1MB of uncompressed code that the browser must parse, compile, and execute. According to the Coverage tool in Chrome DevTools, 3MB of that code is never even executed during the page load.

### Delayed primary image request

The second thing that draws my attention is that the network request for the primary image does not even start until the 30 second mark. It's request #107, out of 195 total requests. 17 other large images are downloaded before the primary image, which quickly uses up the limited bandwidth of this simulated mobile connection.

## Some performance experiments

Looking at waterfall charts and dissecting JavaScript bundles is interesting, but what we really want to get out of a performance teardown is a list of actionable tasks with a rough estimate of how each task will impact the performance of the website. One of my favourite ways to get this list is by running some [A/B performance tests](/using-ab-testing-to-prioritise-performance-optimisations/) by making some optimisations by hand and measuring their impact.

### Prioritise loading the primary image

One of the obvious bottlenecks is the primary image being downloaded so far through the page load. We can improve the user experience by prioritising the primary image. I simulated this optimisation in two steps:

1. Prime the cache for the primary image. While this is not strictly possible in the real world, the effect should be similar to using `<link rel=preload>` to request the primary image as soon as possible.
2. Block all of the other image requests so that the primary image isn't contending for network bandwidth.

The result of this experiment is that the primary image is rendered at **21 seconds** -- **9.4 seconds faster** than the original page.

### Defer loading third party assets

While the majority of the blocking assets belong to TradeMe, there is still a considerable amount of third party content being downloaded -- about 350KB, most of which is JavaScript. Deferring this third party content until later in the page load could improve the user experience by prioritising the first party content.

I simulated this optimisation by blocking requests from all third party domains. The result is a First Interactive time of **9.5 seconds** -- **2.1 seconds faster** than the original page.

### Render page content on the server

Unfortunately the new TradeMe site neither works without JavaScript enabled, nor does it work offline despite utilising a caching service worker. One reason for this is that the page content is fetched and rendered by JavaScript rather than being contained in the initial document response. Rendering some basic content on the server not only enables the page to be used offline or without JavaScript, it also has significant performance benefits since the browser can begin to render content well before it has finished downloading the other page resources.

I simulated this optimisation by creating a static version of the page with the content pre-rendered. I also moved the `<script>` tags to below the main content to prevent them from blocking rendering. Since this version ran in a different environment, I adjust the numbers to account for the difference in backend times. The results were:

- The headline was rendered in **5.7 seconds** -- **15.5 seconds faster** than the original page.
- The primary image was rendered in **11.7 seconds** -- **18.7 seconds faster** than the original page.
- First Interactive is not comparable, since I changed the position of the `<script>` tags.

## Causes for celebration

It's far too easy in a performance teardown to focus on the things that a website gets wrong. I always like to try and find some things that a website is doing right.

#### 1. Caching improve the experience on repeat visits

On the first page load, over 4.2MB of data is transferred. On subsequent page loads, that number is more like 570KB thanks to a caching service worker and sensible caching headers.

## Recommendations

### 1. Test on representative devices and networks

Building great user experiences requires a large dose of empathy, and one of the easiest ways to get this empathy is by using your product in the same way that your "average" user does. Pick up a mid-range Android phone or an Intel Celeron laptop and see how your product feels on those devices. The great thing about "average" devices is that they are cheap - 10-20x cheaper than the MacBook Pro used by the "average" developer.

### 2. Render

### 3. Reduce the amount of JavaScript you ship
