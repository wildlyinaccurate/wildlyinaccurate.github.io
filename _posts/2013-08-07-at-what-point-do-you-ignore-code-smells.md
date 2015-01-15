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

Today I had a lengthy discussion with a colleague about whether or not to add some fields to one of our models. I remember thinking partway through: why are we even discussing this? This is such a trivial task -- surely we can just add the fields now and be done with it.

The thing is, these trivial tasks can be the cause of major headaches down the road. The reason we were having the discussion in the first place is because we didn't need those fields _right then_. There was a chance that we might need them in the future, but it would just be easier to add them now.

Aha -- now that I've mentioned that we didn't actually _need_ the fields, it's glaringly obvious that this was a textbook case of _[You Aren't Gonna Need It](http://en.wikipedia.org/wiki/You_aren)_. They would have been dead code. Despite it being so obvious, this sort of thing seems to happen all the time. It's as if we are consciously ignoring smaller code smells, even when they're right under our nose.

Committing a few lines of dead code may seem like a superficial example, but it could have ended up causing us a lot of pain in the future. If we had added those fields and never used them, what would the long-term cost have been? Eventually, the team would forget about the fields. They weren't documented, because at the time it was obvious that they weren't being used. During refactoring, nobody will know whether it's safe to remove them -- they don't _appear_ to be used, but the developers _just don't know_, so they will simply leave the fields alone.

A few unused fields on a model could end up becoming a major source of **fear, uncertainty, and doubt**. Repeat this situation a couple dozen times, and you end up with a system which nobody understands; a system which is difficult to maintain and develop upon.

I started to think about it some more, and I realised that for every code smell we prevent going into the codebase, there is probably a dozen more that gets in. Just small things like a line that doesn't conform to our coding standards, . And yes, sometimes

-----

Identifying code bloat and other [code smells](http://martinfowler.com/bliki/CodeSmell.html) can actually be pretty hard. There are plenty of examples where something that seems like A Good Thing is actually just code bloat. Take abstraction, for example: for many programmers, abstracting functionality is a basic instinct.

Again, this example might seem superficial, or it might seem like I'm blowing things way out of proportion. But _I've seen this happen_. Experienced teams can crumple under the pressure of maintaining a system that they don't understand.

YAGNI doesn't have to be about big features - it can be subtle code bloat, unnecessary abstractions, or the decision to use a particular library.

What I'm trying to get at here, is that every day we make decisions about seemingly trivial things, without any concern for how that decision might impact us -- and others -- in the long-term. We're all guilty of this, and it's not through any fault of our own. It's for the simple reason that _predicting the future is hard_. How can we possibly know the effects of our decisions until after we've already made them?

I think that part of the solution is to just accept that these things happen, and to fix them as soon as they become a problem. But as software developers we are quite lucky in that we have a lot of control over how we work. We can actually _do something_ to prevent these things becoming a problem.

The other part of the solution is to think about every decision that you and your team makes, and _question_ that decision if it doesn't seem right. Does your User model need fields for a postal address, or is their email address enough? Does that functionality need to be abstracted, or is it never going to be used again? Should you really use Rails for this, or would a simple Sinatra app get the job done?
