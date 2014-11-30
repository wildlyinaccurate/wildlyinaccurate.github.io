---
layout: post
title: 'Understanding JavaScript: Inheritance and the prototype chain'
date: 2014-05-09 22:43:39.000000000 +01:00
categories:
- JavaScript
tags:
- classes
- inheritance
- javascript
- prototype
status: publish
type: post
published: true
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p><em>This is the first post in a series on JavaScript. In this post I'm going to explain how JavaScript's prototype chain works, and how you can use it to achieve inheritance.</em></p>
<p>First, it's important to understand that while JavaScript is an object-oriented language, it is prototype-based and does not implement a traditional class system. Keep in mind that when I mention a <em>class</em> in this post, I am simply referring to JavaScript objects and the prototype chain – more on this in a bit.</p>
<p>Almost everything in JavaScript is an object, which you can think of as sort of like associative arrays - objects contain named properties which can be accessed with <code>obj.propName</code> or <code>obj['propName']</code>. Each object has an internal property called <em>prototype</em>, which links to another object. The prototype object has a prototype object of its own, and so on – this is referred to as the <em>prototype chain</em>. If you follow an object's prototype chain, you will eventually reach the core <code>Object</code> prototype whose prototype is <code>null</code>, signalling the end of the chain.</p>
<p>So what is the prototype chain used for? When you request a property which the object does not contain, JavaScript will look down the prototype chain until it either finds the requested property, or until it reaches the end of the chain. This behaviour is what allows us to create "classes", and implement inheritance.<!--more--></p>
<p>Don't worry if this doesn't make sense yet. To see prototypes in action, let's take a look at the simplest example of a "class" within JavaScript, which is created with a function object:</p>
<pre class="highlight javascript">function Animal() {}

var animal = new Animal();</pre>
<p>We can add properties to the <code>Animal</code> class in two ways: either by setting them as <em>instance properties</em>, or by adding them to the <code>Animal</code> prototype.</p>
<pre class="highlight javascript">function Animal(name) {
    // Instance properties can be set on each instance of the class
    this.name = name;
}

// Prototype properties are shared across all instances of the class. However, they can still be overwritten on a per-instance basis with the `this` keyword.
Animal.prototype.speak = function() {
    console.log("My name is " + this.name);
};

var animal = new Animal('Monty');
animal.speak(); // My name is Monty</pre>
<p>The structure of the <code>Animal</code> object becomes clear when we inspect it in the console. We can see that the <code>name</code> property belongs to the object itself, while <code>speak</code> is part of the <code>Animal</code> prototype.</p>
<p><img class="aligncenter size-full wp-image-845" src="assets/Animal.png" alt="Animal Prototype" width="430" height="106" /></p>
<p>Now let's look at how we can extend the <code>Animal</code> class to create a <code>Cat</code> class:</p>
<pre class="highlight javascript">function Cat(name) {
    Animal.call(this, name);
}

Cat.prototype = new Animal();

var cat = new Cat('Monty');
cat.speak(); // My name is Monty</pre>
<p>What we are doing here is setting <code>Cat</code>'s prototype to an instance of <code>Animal</code>, so that <code>Cat</code> inherits all of <code>Animal's</code> properties. We're also using <code>Animal.call</code> to inherit the <code>Animal</code> constructor (sort of like <code>parent</code> or <code>super</code> in other languages). <code>call</code> is a special function which lets us call a function and specify the value of <code>this</code> <em>within that function</em>. So when <code>this.name</code> is set inside the <code>Animal</code> constructor, it's the <code>Cat</code>'s name property being set, not the <code>Animal</code>'s.</p>
<p>Let's take a look at the <code>Cat</code> object to get a better view of what's going on.</p>
<p><img class="aligncenter size-full wp-image-846" src="assets/Cat.png" alt="Cat" width="430" height="134" /></p>
<p>The <code>Cat</code> object has its own <code>name</code> instance property, like we expected. When we look at the object's prototype we see that it has also inherited <code>Animal</code>'s <code>name</code> instance property as well as the <code>speak</code> prototype property. This is where the prototype chain comes in – when we request <code>cat.name</code>, JavaScript finds the <code>name</code> instance property and doesn't bother going down the prototype chain. However when we request <code>cat.speak</code>, JavaScript has to travel down the prototype chain until it finds the <code>speak</code> property inherited from <code>Animal</code>.</p>
<p>At this point I would recommend going through a few slides of <a href="http://ejohn.org/apps/learn/#64">John Resig's JavaScript Ninja</a> as they go into more detail about how JavaScript prototypes work, and provide some good interactive examples.</p>
