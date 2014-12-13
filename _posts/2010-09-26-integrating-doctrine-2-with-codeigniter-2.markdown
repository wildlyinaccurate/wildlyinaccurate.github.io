---
layout: post
title: Integrating Doctrine 2 with CodeIgniter 2
date: 2010-09-26 00:50:14.000000000 +01:00
categories:
- CodeIgniter
- Doctrine
- PHP
- Web Development
tags:
- codeigniter 2
- combine
- doctrine 2
- guide
status: publish
type: post
published: true
author: Joseph Wynn
---

_If you're looking for a quick way to get Doctrine 2 running with CodeIgniter 2, you might want to download my [CodeIgniter 2/Doctrine 2 package](https://github.com/wildlyinaccurate/CodeIgniter-2-with-Doctrine-2)_

## Overview

CodeIgniter is a great PHP framework. The codebase is clean, the [documentation](http://codeigniter.com/user_guide/) is fantastic, and it's regularly updated. Doctrine is a good ORM for the same reasons: it's very well-written, has [extensive documentation](http://www.doctrine-project.org/projects/orm/2.1/docs/en), and is actively developed. A combination of these two systems makes it easy to build database-oriented web applications quicker than ever before.

To get started, download [CodeIgniter 2](http://codeigniter.com/download.php) and [Doctrine 2](http://www.doctrine-project.org/projects/orm.html) – make sure you use the 'Download Archive' link when downloading Doctrine.

<!--more-->

## Setting up CodeIgniter

Put all of the CodeIgniter files into a directory on your web server, and configure it to your liking. If you need a guide on how to do this, the best place to look is the [CodeIgniter User Guide](http://codeigniter.com/user_guide/). Keep in mind that Doctrine will load the database configuration from CodeIgniter (application/config/database.php).

## Setting up Doctrine

Because Doctrine is an entire system in itself, it worked well as a plugin for CodeIgniter 1. Unfortunately one of the major changes to CodeIgniter 2 is the removal of plugins. EllisLab recommends you refactor your plugins as libraries, so that's exactly what we will do.

Setting up Doctrine as a CodeIgniter library is fairly simple:

1.  Put the Doctrine directory into application/libraries (so that you have a application/libraries/Doctrine directory).
2.  Create the file application/libraries/Doctrine.php. This will be our Doctrine bootstrap as well as the library that CodeIgniter loads.
3.  Copy the following code into Doctrine.php:
```php
&lt;?php

use Doctrine\Common\ClassLoader,
    Doctrine\ORM\Tools\Setup,
    Doctrine\ORM\EntityManager;

class Doctrine
{
    public $em;

    public function __construct()
    {
        require_once __DIR__ . '/Doctrine/ORM/Tools/Setup.php';
        Setup::registerAutoloadDirectory(__DIR__);

        // Load the database configuration from CodeIgniter
        require APPPATH . 'config/database.php';

        $connection_options = array(
            'driver'        =&gt; 'pdo_mysql',
            'user'          =&gt; $db['default']['username'],
            'password'      =&gt; $db['default']['password'],
            'host'          =&gt; $db['default']['hostname'],
            'dbname'        =&gt; $db['default']['database'],
            'charset'       =&gt; $db['default']['char_set'],
            'driverOptions' =&gt; array(
                'charset'   =&gt; $db['default']['char_set'],
            ),
        );

        // With this configuration, your model files need to be in application/models/Entity
        // e.g. Creating a new Entity\User loads the class from application/models/Entity/User.php
        $models_namespace = 'Entity';
        $models_path = APPPATH . 'models';
        $proxies_dir = APPPATH . 'models/Proxies';
        $metadata_paths = array(APPPATH . 'models');

        // Set $dev_mode to TRUE to disable caching while you develop
        $config = Setup::createAnnotationMetadataConfiguration($metadata_paths, $dev_mode = true, $proxies_dir);
        $this-&gt;em = EntityManager::create($connection_options, $config);

        $loader = new ClassLoader($models_namespace, $models_path);
        $loader-&gt;register();
    }
}
```

There are some parts of this file that you might like to modify to suit your needs:

**Lines 34-37:**

```php
$models_namespace = 'Entity';
$models_path = APPPATH . 'models';
$proxies_dir = APPPATH . 'models/Proxies';
$metadata_paths = array(APPPATH . 'models');
```

These lines determine where you need to put your model files, and how you instantiate your model classes. With these settings, your models must live in `application/models/Entity` and be in the `Entity` namespace. For example instantiating a `new Entity\User` would load the User class from `application/models/Entity/User.php`

**Line 40**

```php
$config = Setup::createAnnotationMetadataConfiguration($metadata_paths, $dev_mode = true, $proxies_dir);
```

This line uses Doctrine's `Setup` class to automatically create the metadata configuration. The [Metadata Driver](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/metadata-drivers.html) is what Doctrine uses to interpret your models and map them to the database. In this tutorial I have used the [Annotations Driver](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/annotations-reference.html). If you would like to use a different metadata driver, change `createAnnotationMetadataConfiguration` to one of the methods below:

*   `createXMLMetadataConfiguration` – Uses the [XML Mapping Driver](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/xml-mapping.html)
*   `createYAMLMetadataConfiguration` – Uses the [YAML Mapping Driver](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/yaml-mapping.html)

Notice the `$dev_mode` variable. This should be true while you are developing, as it does a couple of things:

1.  Automatically generates your proxy classes
2.  Uses `ArrayCache`; a non-persistent caching class

Likewise, when `$dev_mode` is false:

1.  Prevents your proxy classes from being overwritten
2.  Attempts to use one of the following persistent caches, in this order: APC, Xcache, Memcache (127.0.0.1:11211), and Redis (127.0.0.1:6379)

## Advanced Configuration

For more advanced configuration, read the [Configuration](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/configuration.html) section of the Doctrine documentation.

## Loading Doctrine

Doctrine can now be loaded in the same way as any other CodeIgniter library:

```php
$this-&gt;load-&gt;library('doctrine');
```

Once the Doctrine library is loaded, you can retrieve the Entity Manage like so:

```php
$em = $this-&gt;doctrine-&gt;em;
```

## Defining Models

Building models using the AnnotationDriver is simple. You can build your classes as if they were regular PHP classes, and define the Doctrine metadata in Docblock annotations.

```php
&lt;?php

namespace Entity;

/**
 * @Entity
 * @Table(name="user")
 */
class User
{
     // ...
}
```

The `@Entity` annotation marks this class for [object-relational persistence](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/basic-mapping.html#persistent-classes). If the table name is not specified (using the `@Table` annotation), Doctrine will create a table with the same name as the class.

Annotations that you will probably use frequently are:

*   `@Column` – Marks a property for object-relational persistence
*   `@OneToOne`, `@ManyToOne` and `@ManyToMany` – Define a relationship between two entities
*   `@JoinTable` – Used when defining a `@ManyToMany` relationship to specify the database join table

For a full list of the available annotations and their uses, see the [Annotation Reference](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/annotations-reference.html)

Below are two sample entities that show a basic one-to-many relationship:

```php
&lt;?php

namespace Entity;

use Doctrine\Common\Collections\ArrayCollection;

/**
 * @Entity
 * @Table(name="user")
 */
class User
{
    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @Column(type="string", length=32, unique=true, nullable=false)
     */
    protected $username;

    /**
     * @Column(type="string", length=64, nullable=false)
     */
    protected $password;

    /**
     * @Column(type="string", length=255, unique=true, nullable=false)
     */
    protected $email;

    /**
     * The @JoinColumn is not necessary in this example. When you do not specify
     * a @JoinColumn annotation, Doctrine will intelligently determine the join
     * column based on the entity class name and primary key.
     *
     * @ManyToOne(targetEntity="Group")
     * @JoinColumn(name="group_id", referencedColumnName="id")
     */
    protected $group;
}

/**
 * @Entity
 * @Table(name="group")
 */
class Group
{
    /**
     * @Id
     * @Column(type="integer", nullable=false)
     * @GeneratedValue(strategy="AUTO")
     */
    protected $id;

    /**
     * @Column(type="string", length=32, unique=true, nullable=false)
     */
    protected $name;

    /**
     * @OneToMany(targetEntity="User", mappedBy="group")
     */
    protected $users;
}
```

It is important to note that any mapped properties on your Entities need to be either `private` or `protected`, otherwise [lazy-loading might not work as expected](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/architecture.html#entities). This means that it is necessary to use Java-styled getter and setter methods:

```php
public function setUsername($username)
{
    $this-&gt;username = $username;
}

public function getUsername()
{
    return $this-&gt;username;
}
```

Thankfully you can save a lot of time and [automatically generate these methods](https://wildlyinaccurate.com/useful-doctrine-2-console-commands#orm-generate-entities) using the `orm:generate-entities` command.

## Setting up the Doctrine Console

This step is optional, however the Doctrine Console has some very useful commands so I highly recommend setting it up.

All you need to do is create the file application/doctrine.php and copy the following code into it:

```php
&lt;?php

define('APPPATH', dirname(__FILE__) . '/');
define('BASEPATH', APPPATH . '/../system/');
define('ENVIRONMENT', 'development');

chdir(APPPATH);

require __DIR__ . '/libraries/Doctrine.php';

foreach ($GLOBALS as $helperSetCandidate) {
    if ($helperSetCandidate instanceof \Symfony\Component\Console\Helper\HelperSet) {
        $helperSet = $helperSetCandidate;
        break;
    }
}

$doctrine = new Doctrine;
$em = $doctrine-&gt;em;

$helperSet = new \Symfony\Component\Console\Helper\HelperSet(array(
    'db' =&gt; new \Doctrine\DBAL\Tools\Console\Helper\ConnectionHelper($em-&gt;getConnection()),
    'em' =&gt; new \Doctrine\ORM\Tools\Console\Helper\EntityManagerHelper($em)
));

\Doctrine\ORM\Tools\Console\ConsoleRunner::run($helperSet);
```

On a Linux or Mac, you can now run `./application/doctrine` from the command line.

If you are on Windows, you can run `php.exe application/doctrine.php` from the command line. If you are new to running PHP scripts from the command line in Windows, you may want to read [PHP's documentation](http://php.net/manual/en/install.windows.commandline.php).

## Using the Doctrine Console

If you run the Doctrine console with no arguments, you will be presented with a list of the available commands. For now, we are only interested in the `orm:schema-tool` commands. If you would like to learn about the other commands you can run a command with the `--help` flag or read my quick [Doctrine console overview](https://wildlyinaccurate.com/useful-doctrine-2-console-commands).

**orm:schema-tool:create** will create tables in your database based on your Doctrine models.

**orm:schema-tool:drop** will do the exact opposite. It is worth noting that this command will only drop tables which have correlating Doctrine models. Any tables that aren't mapped to a Doctrine model will be left alone.

**orm:schema-tool:update** will determine if your database schema is out-of-date, and give you the option of updating it. You can execute this command with the `--dump-sql` flag to see the changes, or the `--force` flag to execute the changes.

## Using Doctrine

Once your models are set up and your database is built, you can access your models using the Doctrine EntityManager. I like shortcuts, so I always instantiate the EntityManager in MY_Controller:

```php
&lt;?php

class MY_Controller extends Controller
{
    // Doctrine EntityManager
    public $em;

    function __construct()
    {
        parent::__construct();

        // Not required if you autoload the library
        $this-&gt;load-&gt;library('doctrine');

        $this-&gt;em = $this-&gt;doctrine-&gt;em;
    }
}
```

Instead of the longer `$this->doctrine->em`, this will allow you to access the EntityManager using `$this->em`:

```php
$user = new Entity\User;
$user-&gt;setUsername('Joseph');
$user-&gt;setPassword('secretPassw0rd');
$user-&gt;setEmail('josephatwildlyinaccuratedotcom');

$this-&gt;em-&gt;persist($user);
$this-&gt;em-&gt;flush();
```

## Final Words

If you have been spoiled by Doctrine 1's magic then you will probably have a hard time wrapping your head around Doctrine 2's strict object-oriented approach to everything. When learning your way around a new system, documentation can be your best friend or your worst enemy. Lucky for us, the Doctrine team has written some fantastic documentation. If you are having trouble getting something to work, one of the first things you should do is <abbr title="Read The Manual">RTFM</abbr> ([Doctrine](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/index.html); [CodeIgniter](http://codeigniter.com/user_guide/)).

Good luck, I hope you enjoy using these powerful tools!
