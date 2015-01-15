---
layout: post
title: 'Reason Tutorial: Making a Heavy Dubstep Bass'
date: 2012-11-17 00:32:33.000000000 +00:00
categories:
- Music Production
tags: []
status: draft
type: post
published: false
author: Joseph Wynn
---

Dubstep is well-known for its "wobble" bass, but frankly I'm bored of hearing track after track using that same bass sound. The "wobble" characteristic that defines a dubstep bass is a low frequency oscillator (LFO) routed to a low pass (LP) filter's frequency. The oscillation of the LP filter frequency gives the bass an effect not dissimilar to turning the volume up and down.

Sticking with the theme of creating interesting sounds simply by varying the volume and frequency of an instrument's output, I created a bass that delays the effects of the LP filter by adding a long attack to the filter envelope.<!--more-->

The finished product will sound something like this: {% audio /assets/Bass-Full-Demo.mp3 %}

Let's get started. In a combinator, create a Thor synthesizer. The bass we're going to build will be based on a preset patch called DnB Bass, so click the little folder icon to open up the Patch Browser and look for DnB Bass.thor in the Bass folder.

{% responsive_image path: assets/blank-rack.jpg alt: "DnB Bass" %}

This DnB Bass patch is a great start to a deep, growly dubstep bass. We're going to need to modify it and add some effects to get it sounding the way we want though. Make sure the Thor programmer is showing (click the Show Programmer button to the right of the pitch bend and mod wheel). Make the following changes:

1.  Set the balance of oscillator #1 and #2 to 40. This will give the sawtooth osc more volume, and give the synth a harsh and raw feel.
2.  Set the filter envelope attack to about 400ms. This makes the filter kick in a little sooner.
3.  Turn the shaper off.
