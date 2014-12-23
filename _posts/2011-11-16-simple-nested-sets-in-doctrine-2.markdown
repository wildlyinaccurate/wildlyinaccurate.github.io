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
author: Joseph Wynn
---

Unlike Doctrine 1 with it's NestedSet behaviour, there is no nested set functionality in the core of Doctrine 2. There are a few extensions available that offer nested set support:

*   [DoctrineExtensions by Gediminas Morkevicius](https://github.com/l3pp4rd/DoctrineExtensions)
*   [Doctrine2 Hierarchical Structural Behavior by Guilherme Blanco](https://github.com/guilhermeblanco/Doctrine2-Hierarchical-Structural-Behavior)
*   [Doctrine2 NestedSet by Brandon Turner](https://github.com/blt04/doctrine2-nestedset)

I tried all of these extensions, but none of them felt simple or lightweight enough for my application. What I wanted to do was have a Category entity which could have a tree of sub-categories, e.g:<!--more-->

```
Food
    Pizza
        Margherita
        La Reine
        Giardiniera
    Chocolate
        Dark
        Milk
        White
```

The simplest way I found of doing this without using any extensions was to make use of <abbr title="Standard PHP Library">SPL</abbr>'s [RecursiveIterator](http://php.net/manual/en/class.recursiveiterator.php) and [RecursiveIteratorIterator](http://www.php.net/manual/en/class.recursiveiteratoriterator.php) classes. Here's the final code, to output a drop-down menu like this one:

{% responsive_image path: assets/dropdown.png alt: "Hierarchical Dropdown" %}

```php
/** @var $em \Doctrine\ORM\EntityManager */
$root_categories = $em->getRepository('Entity\Category')->findBy(array('parent_category' => null));

$collection = new Doctrine\Common\Collections\ArrayCollection($root_categories);
$category_iterator = new Entity\RecursiveCategoryIterator($collection);
$recursive_iterator = new RecursiveIteratorIterator($category_iterator, RecursiveIteratorIterator::SELF_FIRST);

foreach ($recursive_iterator as $index => $child_category)
{
    echo '<option value="' . $child_category->getId() . '">' . str_repeat('&amp;nbsp;&amp;nbsp;', $recursive_iterator->getDepth()) . $child_category->getTitle() . '</option>';
}
```

Here's how it's done. Start out with an entity class that looks something like this:

```php
namespace Entity;

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
        $this->child_categories = new \Doctrine\Common\Collections\ArrayCollection;
    }

    // Getters and setters ...

}
```

Next, the RecursiveCategoryIterator class. I have written this to interface with Doctrine's Collection object, but it could easily be re-written to work with native PHP arrays (see [this note](http://www.php.net/manual/en/class.recursiveiterator.php#106034) in the PHP manual for an example of a RecursiveIterator class that uses native arrays).

```php
namespace Entity;

use Doctrine\Common\Collections\Collection;

class RecursiveCategoryIterator implements \RecursiveIterator
{

    private $_data;

    public function __construct(Collection $data)
    {
        $this->_data = $data;
    }

    public function hasChildren()
    {
        return ( ! $this->_data->current()->getChildCategories()->isEmpty());
    }

    public function getChildren()
    {
        return new RecursiveCategoryIterator($this->_data->current()->getChildCategories());
    }

    public function current()
    {
        return $this->_data->current();
    }

    public function next()
    {
        $this->_data->next();
    }

    public function key()
    {
        return $this->_data->key();
    }

    public function valid()
    {
        return $this->_data->current() instanceof \Entity\Category;
    }

    public function rewind()
    {
        $this->_data->first();
    }

}
```

That's everything! A very simple Nested Set behaviour in Doctrine 2 using only a simple RecursiveIterator class – no complicated extensions.

_Edit: As Hans has pointed out, while this approach does allow us to model hierarchies, it is not truly a nested set model as it does not number each node to allow for tree traversal. This model is probably closer to an [adjacency list](http://en.wikipedia.org/wiki/Adjacency_list)._
