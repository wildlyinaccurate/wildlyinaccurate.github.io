---
layout: post
title: What it's like to work as a developer at BBC News
categories:
- BBC News
tags:
- bbc news
- culture
author: Joseph Wynn
extra_head:
  - <link rel="stylesheet" href="/css/toc.css">
---

The BBC is a pretty large organisation. Today it employs around 20,000 people (actually around 35,000 when you include part-time and fixed-term contract employees) across a huge number of divisions. The [BBC Careers website](http://careerssearch.bbc.co.uk/) typically has over 100 vacancies posted on any given day. Before I joined the BBC, I found the sheer scale of it a bit intimidating. Usually I can get an idea of what it's like to work for a company by reading their job advertisements and their engineering blogs, but with the BBC I was almost completely clueless.

In this post I hope to shed some light on what it's like to work as a developer or tester for BBC News. It's worth noting that from an engineering perspective, the BBC is not like most other companies — it's more like dozens of smaller companies, each with their own engineering department, working towards a common goal. [News](http://www.bbc.com/news), [Sport](http://www.bbc.com/sport), [Programmes](http://www.bbc.co.uk/programmes), [iPlayer](http://www.bbc.co.uk/iplayer), [Radio](http://www.bbc.co.uk/radio)... As digital products, these are all built mostly independently of each other. I work for BBC News, so a lot of what I've written may not apply outside of BBC News.<!--more-->

* Placeholder list item
{:toc}

## Teams & projects

> Note: When I say "BBC News", I mean "BBC News and BBC World Service". The [30 or so World Service sites](http://www.bbc.co.uk/ws/languages) run on the same **Responsive News** codebase as BBC News. For this reason, the World Service and News teams consider themselves to be part of the same overarching team.

There are about 6 BBC News development teams at any one time. Teams tend to form around projects which can last anywhere between a month (building a small routing service for the BBC's RSS feeds) to 9 months (rebuilding the BBC News front page with a new technology stack). As well as developers, each team typically also has a dedicated tester, business analyst, project manager, and product owner.

In the past, teams were relatively static and people didn't move around much between projects. More recently though, the teams have been shuffling a lot more. We don't have a formal team rotation system in place at the moment, but it's easy to move between teams if you want to work on something new. I've worked on 3 different teams over the last two years.

As well as collaboration between these BBC News teams, we also regularly collaborate with teams from all around the BBC. In the last 3 months alone, my team has worked with:

 * The Local News team in Cardiff.
 * The Sport and Live teams and the Accessibility Champions group in Manchester.
 * The Worldwide team in West London.
 * The Weather, Programmes, and Radio teams in Central London.

## Learning & personal development

BBC staff can attend [BBC Academy](http://www.bbc.co.uk/academy) courses for free. There are _so many_ courses available covering subjects across journalism, broadcasting, technology, management, and personal development — just to name a few. You can even earn a MSCS (Masters of Science in Computer Science) by completing Academy courses over a 22-month period.

We give a [Pluralsight](https://www.pluralsight.com/) license to every new starter.

We have an office library, and an annual budget for purchasing new books.

We run a _developer gathering_ every month where developers and testers from BBC News and other teams around the BBC give technical talks and open the floor to discussions.

We run a similar but less technical _town hall_ every fortnight where people from all around BBC News (including editorial staff) give 5 minute lightning talks about what's going on in their world.

There is a budget for attending external events & conferences.

Most teams have a dedicated _learning day_ once every two weeks where everybody is encouraged to spend their time learning something new.

On top of learning days, most managers will encourage you to dedicate at least a few days each month to personal development.

We have regular personal development reviews where your manager will recommend training courses and learning resources to help you achieve your personal goals.

## Working hours & annual leave

The BBC has a "core hours" system where you are required to work between 10am and 4pm. Other than that, you can pretty much work whichever hours you like so long as you work all of your contracted hours (usually 35 hours per week). I come in at 8am every day and leave at 4pm. Some of my colleagues come in at 10am and leave at 6pm.

Working from home is common, and is done at your manager's discretion. Many people regularly work from home one day each week.

Overtime is actively discouraged. No project is more important than your wellbeing!

Taking annual leave is never an issue, provided you give enough notice. If you work on a project with a "hard" deadline like an election or sporting event, your manager might ask you to avoid taking leave in the weeks leading up to the deadline, but this is not mandatory.

## Technologies

Most of the software we write is written in Ruby, JavaScript, and PHP. Teams have the freedom to use whichever technologies they like, provided there is sufficient justification. Here's a sample of technologies I've worked with so far at BBC News:

 * Responsive News is PHP application which uses [a range of interesting techniques](http://responsivenews.co.uk/post/123104512468/13-tips-for-making-responsive-web-design) to support all of the World Service languages and scripts.
 * The BBC News [AMP project](https://www.ampproject.org/) and many of the worldwide elections components are powered by an open-source [broker-renderer](https://en.wikipedia.org/wiki/Broker_Pattern) framework called [Alephant](https://github.com/BBC-News/alephant).
 * The BBC News front page is being rebuilt using React on a [highly-scalable Node.js platform](https://www.youtube.com/watch?v=pxmXiKlh5OU) developed by BBC Sport.
 * One of our page composition systems is powered by services written in Ruby and Go.

## Other perks & local discounts

All BBC News engineering staff are located in [New Broadcasting House](http://www.bbc.co.uk/broadcastinghouse/), just down the road from Oxford Circus. This puts us somewhat dangerously close to dozens of really great shops, restaurants, cafés, and bars. Many of them offer a discount to BBC employees.

The BBC runs a centralised benefits scheme which offers things like:

 * A great pension plan.
 * Dental, health, and travel insurance.
 * Childcare vouchers.
 * Access to [Cyclescheme](https://www.cyclescheme.co.uk/).
 * The ability to buy and sell annual leave.
