---
layout: post
title: When did dependency management get so complicated?
date: 2013-06-09 22:48:47.000000000 +01:00
categories:
- Thoughts
tags:
- bower
- environment
- npm
- vagrant
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>This evening I wanted to start hacking on a <a href="https://github.com/wildlyinaccurate/wildly-minimalistic-wordpress-theme">project of mine</a>, which is a simple WordPress theme. My main development machine was being used by somebody else, so I decided to boot up my old Sony Vaio running Ubuntu. <em>It'll be simple</em>, I thought. <em>I've just got to clone the repo, run <code>npm install</code>, <code>bower install</code>, and <code>grunt build</code>, and I'll be good to go</em>. I was wrong.</p>
<p>First, the version of npm installed on the laptop is apparently so out-of-date that it can't run the install. So I let it update itself (and all the other packages I have installed - why not?) with <code>sudo npm -g update</code>. Being a Sunday night, my broadband connection is running spectacularly slow, so the update process takes about 10 minutes at 40kB/s. But hey, at least now I can run <code>npm install</code>, right?</p>
<p>Nope. Now npm is throwing some errors with unhelpful messages, but that's fine, I'll just trawl through the error log. 5 minutes later, I figure out that ~/tmp belongs to root (probably from running <code>npm update</code> as root). Ok, fine, I'll change the permissions and try again. This time <code>npm install</code> works! But of course, my connection is so horribly slow and grunt has so many dependencies that the install process takes <strong>over 15 minutes</strong>.<!--more--></p>
<p>After all of that, I can <em>finally</em> run <code>bower install</code>, and then I can build the damn project and start hacking. At least bower works first try, but now it's got to clone all of these repos, which takes another 5 minutes on my slow connection. By the time I've run <code>grunt build</code> and started hacking, over 30 minutes has passed and I'm <em>really</em> pissed off.</p>
<p>Did this process really have to be so complicated? I remember a time when things were much simpler. I could checkout a project and build it in 5 minutes - all the dependencies were already installed globally from working on other projects. I didn't need to have a local copy of grunt <em>and all of its dependencies</em>. Third-party components were part of the checkout; I didn't have to checkout their entire repos along with tests, documentation, and other junk I don't need.<em><br />
</em></p>
<p>When you throw virtual environments into the mix, things get even more complicated. What if I had to download a Vagrant box to set the project up? This process could've taken <em>hours</em>. Don't get me wrong, I use package management tools like npm, bundler and bower on a daily basis. They make my life easier, most of the time. But sometimes I feel like they can make things <em>so</em> complicated, and it makes me think we've taken a massive step backwards in terms of simplicity and productivity.</p>
