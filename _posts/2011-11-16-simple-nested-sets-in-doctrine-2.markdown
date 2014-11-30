---
layout: post
title: Simple Nested Sets in Doctrine 2
date: 2011-11-16 22:26:46.000000000 +00:00
categories:
- Doctrine
- PHP
- Web Development
tags:
- doctrine 2
- Nested Set
- RecursiveIterator
- RecursiveIteratorIterator
- SPL
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
<p>Unlike Doctrine 1 with it's NestedSet behaviour, there is no nested set functionality in the core of Doctrine 2. There are a few extensions available that offer nested set support:</p>
<ul>
<li><a href="https://github.com/l3pp4rd/DoctrineExtensions">DoctrineExtensions by Gediminas Morkevicius</a></li>
<li><a href="https://github.com/guilhermeblanco/Doctrine2-Hierarchical-Structural-Behavior">Doctrine2 Hierarchical Structural Behavior by Guilherme Blanco</a></li>
<li><a href="https://github.com/blt04/doctrine2-nestedset">Doctrine2 NestedSet by Brandon Turner</a></li>
</ul>
<p>I tried all of these extensions, but none of them felt simple or lightweight enough for my application. What I wanted to do was have a Category entity which could have a tree of sub-categories, e.g:<!--more--></p>
<pre class="no-highlight">Food
    Pizza
        Margherita
        La Reine
        Giardiniera
    Chocolate
        Dark
        Milk
        White</pre>
<p>The simplest way I found of doing this without using any extensions was to make use of <abbr title="Standard PHP Library">SPL</abbr>'s <a href="http://php.net/manual/en/class.recursiveiterator.php">RecursiveIterator</a> and <a href="http://www.php.net/manual/en/class.recursiveiteratoriterator.php">RecursiveIteratorIterator</a> classes. Here's the final code, to output a drop-down menu like this one:</p>
<p><a href="https://wildlyinaccurate.com/wp-content/uploads/2011/11/dropdown.png"><img class="size-full wp-image-322 aligncenter" title="Hierarchical Dropdown" alt="" src="assets/dropdown.png" width="162" height="200" /></a></p>
<pre class="highlight-php">/** @var $em \Doctrine\ORM\EntityManager */
$root_categories = $em-&gt;getRepository('Entity\Category')-&gt;findBy(array('parent_category' =&gt; null));

$collection = new Doctrine\Common\Collections\ArrayCollection($root_categories);
$category_iterator = new Entity\RecursiveCategoryIterator($collection);
$recursive_iterator = new RecursiveIteratorIterator($category_iterator, RecursiveIteratorIterator::SELF_FIRST);

foreach ($recursive_iterator as $index =&gt; $child_category)
{
    echo '&lt;option value="' . $child_category-&gt;getId() . '"&gt;' . str_repeat('&amp;nbsp;&amp;nbsp;', $recursive_iterator-&gt;getDepth()) . $child_category-&gt;getTitle() . '&lt;/option&gt;';
}</pre>
<p>Here's how it's done. Start out with an entity class that looks something like this:</p>
<pre class="highlight-php">namespace Entity;

/**
 * @Entity
 * @Table(name="category")
 */
class Category
{

    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="IDENTITY")
     */
    protected $id;

    /**
     * @Column(type="string", length=130, nullable=false)
     */
    protected $title;

    /**
     * @ManyToOne(targetEntity="Category", inversedBy="child_categories")
     * @JoinColumn(name="parent_category_id", referencedColumnName="id")
     */
    protected $parent_category;

    /**
     * @OneToMany(targetEntity="Category", mappedBy="parent_category")
     */
    protected $child_categories;

    public function __construct()
    {
        $this-&gt;child_categories = new \Doctrine\Common\Collections\ArrayCollection;
    }

    // Getters and setters ...

}</pre>
<p>Next, the RecursiveCategoryIterator class. I have written this to interface with Doctrine's Collection object, but it could easily be re-written to work with native PHP arrays (see <a href="http://www.php.net/manual/en/class.recursiveiterator.php#106034">this note</a> in the PHP manual for an example of a RecursiveIterator class that uses native arrays).</p>
<pre class="highlight-php">namespace Entity;

use Doctrine\Common\Collections\Collection;

class RecursiveCategoryIterator implements \RecursiveIterator
{

    private $_data;

    public function __construct(Collection $data)
    {
        $this-&gt;_data = $data;
    }

    public function hasChildren()
    {
        return ( ! $this-&gt;_data-&gt;current()-&gt;getChildCategories()-&gt;isEmpty());
    }

    public function getChildren()
    {
        return new RecursiveCategoryIterator($this-&gt;_data-&gt;current()-&gt;getChildCategories());
    }

    public function current()
    {
        return $this-&gt;_data-&gt;current();
    }

    public function next()
    {
        $this-&gt;_data-&gt;next();
    }

    public function key()
    {
        return $this-&gt;_data-&gt;key();
    }

    public function valid()
    {
        return $this-&gt;_data-&gt;current() instanceof \Entity\Category;
    }

    public function rewind()
    {
        $this-&gt;_data-&gt;first();
    }

}</pre>
<p>That's everything! A very simple Nested Set behaviour in Doctrine 2 using only a simple RecursiveIterator class – no complicated extensions.</p>
<p><em>Edit: As Hans has pointed out, while this approach does allow us to model hierarchies, it is not truly a nested set model as it does not number each node to allow for tree traversal. This model is probably closer to an <a href="http://en.wikipedia.org/wiki/Adjacency_list">adjacency list</a>.</em></p>
