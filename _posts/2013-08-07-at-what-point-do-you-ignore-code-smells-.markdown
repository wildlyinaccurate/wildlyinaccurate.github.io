---
layout: post
title: At what point do you ignore code smells?
date: 2013-08-07 20:37:20.000000000 +01:00
categories:
- Thoughts
tags: []
status: draft
type: post
published: false
author: Joseph Wynn
---
<p>Today I had a lengthy discussion with a colleague about whether or not to add some fields to one of our models. I remember thinking partway through: why are we even discussing this? This is such a trivial task -- surely we can just add the fields now and be done with it.</p>
<p>The thing is, these trivial tasks can be the cause of major headaches down the road. The reason we were having the discussion in the first place is because we didn't need those fields <em>right then</em>. There was a chance that we might need them in the future, but it would just be easier to add them now.</p>
<p>Aha -- now that I've mentioned that we didn't actually <em>need</em> the fields, it's glaringly obvious that this was a textbook case of <em><a href="http://en.wikipedia.org/wiki/You_aren't_gonna_need_it">You Aren't Gonna Need It</a></em>. They would have been dead code. Despite it being so obvious, this sort of thing seems to happen all the time. It's as if we are consciously ignoring smaller code smells, even when they're right under our nose.</p>
<p><span style="line-height: 1.6;">Committing a few lines of dead code may seem like a superficial example, but it could have ended up causing us a lot of pain in the future. If we had added those fields and never used them, what would the long-term cost have been? Eventually, the team would forget about the fields. They weren't documented, because at the time it was obvious that they weren't being used. During refactoring, nobody will know whether it's safe to remove them -- they don't </span><em style="line-height: 1.6;">appear</em><span style="line-height: 1.6;"> to be used, but the developers </span><em style="line-height: 1.6;">just don't know</em><span style="line-height: 1.6;">, so they will simply leave the fields alone.</span></p>
<p>A few unused fields on a model could end up becoming a major source of <strong>fear, uncertainty, and doubt</strong>. Repeat this situation a couple dozen times, and you end up with a system which nobody understands; a system which is difficult to maintain and develop upon.</p>
<p>I started to think about it some more, and I realised that for every code smell we prevent going into the codebase, there is probably a dozen more that gets in. Just small things like a line that doesn't conform to our coding standards, . And yes, sometimes</p>
<p>-----</p>
<p>Identifying code bloat and other <a href="http://martinfowler.com/bliki/CodeSmell.html">code smells</a> can actually be pretty hard. There are plenty of examples where something that seems like A Good Thing is actually just code bloat. Take abstraction, for example: for many programmers, abstracting functionality is a basic instinct.</p>
<p><span style="line-height: 1.6;">Again, this example might seem superficial, or it might seem like I'm blowing things way out of proportion. But</span><em style="line-height: 1.6;"> I've seen this happen</em><span style="line-height: 1.6;">. Experienced teams can crumple under the pressure of maintaining a system that they don't understand.</span></p>
<p>YAGNI doesn't have to be about big features - it can be subtle code bloat, unnecessary abstractions, or the decision to use a particular library.</p>
<p>What I'm trying to get at here, is that every day we make decisions about seemingly trivial things, without any concern for how that decision might impact us -- and others -- in the long-term. We're all guilty of this, and it's not through any fault of our own. It's for the simple reason that <em>predicting the future is hard</em>. How can we possibly know the effects of our decisions until after we've already made them?</p>
<p>I think that part of the solution is to just accept that these things happen, and to fix them as soon as they become a problem. But as software developers we are quite lucky in that we have a lot of control over how we work. We <em></em>can actually <em>do something </em>to prevent these things becoming a problem.</p>
<p>The other part of the solution is to t<span style="line-height: 1.6;">hink about every decision that you and your team makes, and </span><em style="line-height: 1.6;">question</em><span style="line-height: 1.6;"> that decision if it doesn't seem right</span><span style="line-height: 1.6;">. </span><span style="line-height: 1.6;">Does your User model need fields for a postal address, or is their email address enough? Does that functionality need to be abstracted, or is it never going to be used again? Should you really use Rails for this, or would a simple Sinatra app get the job done?</span></p>
