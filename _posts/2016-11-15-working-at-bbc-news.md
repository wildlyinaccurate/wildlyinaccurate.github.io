---
layout: post
title: What it's like to work as a developer at BBC News
categories:
- BBC News
tags:
- bbc news
- culture
published: false
author: Joseph Wynn
---

The BBC is a pretty large organisation. Today it employs around 20,000 people (actually around 35,000 when you include part-time and fixed-term contract employees) across a huge number of divisions. The [BBC Careers website](http://careerssearch.bbc.co.uk/) typically has over 100 vacancies posted on any given day. As an outsider, I found it difficult to gain any insight as to what it would be like to work in an organisation like the BBC. In this post, I hope to shed some light on what it's like to work as a developer (or a tester!) in BBC News and BBC World Service.<!--more-->

But first, a little trip down memory lane.

Back in 2012, while I was working for IPC Media (now Time Inc. UK), I started reading [responsivenews.co.uk](http://responsivenews.co.uk/). The posts were written by developers who were working on the newest incarnation of the BBC News website. For me, this was the first insight into what sort of things developers at the BBC actually _did_. I remember reading the posts on that blog and realising that some of the technologies and techniques they were talking about were really inspiring, and sometimes quite groundbreaking. In fact, the Responsive News blog was one of the main reasons I decided that I wanted to work for BBC News! Some of the highlights of that blog for me were:

 * The notion of a progressively enhancing a page by [cutting the mustard](http://responsivenews.co.uk/post/18948466399/cutting-the-mustard), a JavaScript heuristic for detecting "modern" browsers.
 * [The Responsive News device testing strategy](http://responsivenews.co.uk/post/50028612882/responsive-news-testing), which was the first time I realised how important testing on real devices is.
 * The announcement of [Wraith](http://responsivenews.co.uk/post/56884056177/wraith), a now-ubiquitous visual regression testing tool.
 * And the [approach to building a responsive website alongside an existing desktop website](http://responsivenews.co.uk/post/51567651162/response-ish-web-design), which inspired many passionate discussions about mobile/desktop versus responsive at IPC.

If you're thinking that these are all boring, standard techniques and tools, remember that in 2012 the web development world was still arguing about whether to build their mobile site with _jQuery Mobile_ or _Sencha Touch_. Heck, in 2012 the web development world was still convincing itself that Flash wasn't going anywhere fast. Nice one, 2012.

Fast forward to 2014, and I found myself quite suddenly looking for work. On a whim, I applied for a web developer role at the BBC. Despite reading the Responsive News blog and speaking to some BBC News developers, I still didn't feel like I knew exactly what I was applying for. Sure, I knew that I'd be writing some PHP and JavaScript. Maybe a bit of Ruby. I heard that the Responsive News codebase had plenty of unit tests and a comprehensive Cucumber test suite. But I was still nervous about joining a large company like the BBC. What would my team be like? Would I just churn out code all day and never learn anything new? Would it be difficult to take annual leave?

I was actually so nervous about it that when the BBC offered me a position, I turned it down.

Eventually, after a couple of emails and a phone call, a very friendly chap (hi Oli!) convinced me that working at the BBC was pretty great and I should at least give it a shot. So I did. Two years later, I still think it's one of the best decisions I've made.

So what could I write here that would have put myself at ease two years ago?

## Teams & projects

_Note: When I say to "BBC News", I mean "BBC News and BBC World Service". The [30 or so World Service sites](http://www.bbc.co.uk/ws/languages) actually run on the same Responsive News codebase as BBC News. For this reason, World Service and News developers consider themselves to be part of the same big team._

There are about 6 BBC News development teams at any one time. Teams tend to form around projects which can last anywhere between a month (building a small routing service for the BBC's RSS feeds) to 6 months (rebuilding the BBC News front page on a new stack). As well as developers, each team typically also has their own tester(s), business analyst, project manager, and product owner. This structure is great because everybody is focused on supporting each other to achieve a common goal.

In the past, teams have usually stuck together when they move onto a new project. More recently though, the teams have been shuffling a lot more. We don't have a formal team rotation system in place at the moment, but it's easy to move between teams if you want to work on something new. I've worked on 3 different teams over the last two years.

We also regularly collaborate with teams from all around the BBC. In the last 3 months alone, I have worked with:

 * The Local News team in Cardiff.
 * The Sport and Live teams and the Accessibility Champions group in Manchester.
 * The Worldwide team in West London.
 * The Weather, Programmes, and Radio teams in Central London.

## Learning & personal development

BBC staff can attend [BBC Academy](http://www.bbc.co.uk/academy) courses for free. There are _so many_ courses available covering subjects across journalism, broadcasting, technology, management, personal development, just to name a few. You can even earn a BBC-funded MSCS (Masters of Science in Computer Science) by completing Academy courses over a 22-month period.

Anyone in BBC News can get a [Pluralsight](https://www.pluralsight.com/) license.

We have an office library, and a (pretty generous) annual budget for purchasing new books.

There is a budget for attending events & conferences.

Most teams have a dedicated _learning day_ once every two weeks where everybody is encouraged to spend their time learning something new.

On top of learning days, most managers will encourage you to dedicate at least a few days each month to learning and attending training courses.

We have regular personal development reviews where your manager will recommend training courses and learning resources to help you achieve your personal goals.

## Working hours & annual leave

The BBC has a "core hours" system where you are required to work between 10am and 4pm. Other than that, you can pretty much work whichever hours you like so long as you work all of your contracted hours (usually 35 hours per week). I come in at 8am every day and leave at 4pm. Some of my colleagues come in at 10am and leave at 6pm.

Working from home is common, and is done at your manager's discretion. Many people regularly work from home one day each week.

Overtime is actively discouraged. No project is more important than your wellbeing!

Taking annual leave is never an issue, provided you give enough notice. If you work on a project with a "hard" deadline like an election or sporting event, your manager might ask you to avoid taking leave in the weeks leading up to the deadline, but this is not mandatory.

## Technologies

Most of the software we write is written in Ruby, JavaScript, and PHP. Teams have the freedom to use whichever technologies they like, provided there is sufficient justification. Here's a sample of technologies I've worked with so far at BBC News:

 * Responsive News is PHP application which uses [a range of interesting techniques](http://responsivenews.co.uk/post/123104512468/13-tips-for-making-responsive-web-design) to support all of the World Service languages and scripts.
 * The BBC News [AMP pages](https://www.ampproject.org/) and many of the worldwide elections components are powered by an open-source [broker-renderer](https://en.wikipedia.org/wiki/Broker_Pattern) framework called [Alephant](https://github.com/BBC-News/alephant).
 * The BBC News front page is being rebuilt using React on a [highly-scalable Node.js platform](https://www.youtube.com/watch?v=pxmXiKlh5OU) developed by BBC Sport.
 * One of our page composition systems is powered by services written in Ruby and Go.

## Other perks & local discounts

Having an office right by Oxford Circus in the centre of London puts us (somewhat dangerously) close to dozens of really great shops, restaurants, cafés, and bars. Many of them offer a discount to BBC employees.

The BBC runs a centralised benefits scheme which offers things like:

 * A great pension plan.
 * Dental, health, and travel insurance.
 * Access to [Cyclescheme](https://www.cyclescheme.co.uk/).
 * Buying and selling annual leave.
