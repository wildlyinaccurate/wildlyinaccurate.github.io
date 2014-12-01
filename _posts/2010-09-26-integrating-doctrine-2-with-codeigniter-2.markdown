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
<p><em>If you're looking for a quick way to get Doctrine 2 running with CodeIgniter 2, you might want to download my <a href="https://github.com/wildlyinaccurate/CodeIgniter-2-with-Doctrine-2">CodeIgniter 2/Doctrine 2 package</a></em></p>
<h2>Overview</h2>
<p>CodeIgniter is a great PHP framework. The codebase is clean, the <a href="http://codeigniter.com/user_guide/">documentation</a> is fantastic, and it's regularly updated. Doctrine is a good ORM for the same reasons: it's very well-written, has <a href="http://www.doctrine-project.org/projects/orm/2.1/docs/en">extensive documentation</a>, and is actively developed. A combination of these two systems makes it easy to build database-oriented web applications quicker than ever before.</p>
<p>To get started, download <a href="http://codeigniter.com/download.php">CodeIgniter 2</a> and <a href="http://www.doctrine-project.org/projects/orm.html">Doctrine 2</a> – make sure you use the 'Download Archive' link when downloading Doctrine.</p>
<p><!--more--></p>
<h2>Setting up CodeIgniter</h2>
<p>Put all of the CodeIgniter files into a directory on your web server, and configure it to your liking. If you need a guide on how to do this, the best place to look is the <a href="http://codeigniter.com/user_guide/">CodeIgniter User Guide</a>. Keep in mind that Doctrine will load the database configuration from CodeIgniter (application/config/database.php).</p>
<h2>Setting up Doctrine</h2>
<p>Because Doctrine is an entire system in itself, it worked well as a plugin for CodeIgniter 1. Unfortunately one of the major changes to CodeIgniter 2 is the removal of plugins. EllisLab recommends you refactor your plugins as libraries, so that's exactly what we will do.</p>
<p>Setting up Doctrine as a CodeIgniter library is fairly simple:</p>
<ol>
<li>Put the Doctrine directory into application/libraries (so that you have a application/libraries/Doctrine directory).</li>
<li>Create the file application/libraries/Doctrine.php. This will be our Doctrine bootstrap as well as the library that CodeIgniter loads.</li>
<li>Copy the following code into Doctrine.php:</li>
</ol>
<pre class="highlight-php">&lt;?php

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
}</pre>
<p>There are some parts of this file that you might like to modify to suit your needs:</p>
<p><strong>Lines 34-37:</strong></p>
<pre class="highlight-php">$models_namespace = 'Entity';
$models_path = APPPATH . 'models';
$proxies_dir = APPPATH . 'models/Proxies';
$metadata_paths = array(APPPATH . 'models');</pre>
<p>These lines determine where you need to put your model files, and how you instantiate your model classes. With these settings, your models must live in <code>application/models/Entity</code> and be in the <code>Entity</code> namespace. For example instantiating a <code>new Entity\User</code> would load the User class from <code>application/models/Entity/User.php</code></p>
<p><strong>Line 40</strong></p>
<pre class="highlight-php">$config = Setup::createAnnotationMetadataConfiguration($metadata_paths, $dev_mode = true, $proxies_dir);</pre>
<p>This line uses Doctrine's <code>Setup</code> class to automatically create the metadata configuration. The <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/metadata-drivers.html">Metadata Driver</a> is what Doctrine uses to interpret your models and map them to the database. In this tutorial I have used the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/annotations-reference.html">Annotations Driver</a>. If you would like to use a different metadata driver, change <code>createAnnotationMetadataConfiguration</code> to one of the methods below:</p>
<ul>
<li><code>createXMLMetadataConfiguration</code> – Uses the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/xml-mapping.html">XML Mapping Driver</a></li>
<li><code>createYAMLMetadataConfiguration</code> – Uses the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/yaml-mapping.html">YAML Mapping Driver</a></li>
</ul>
<p>Notice the <code>$dev_mode</code> variable. This should be true while you are developing, as it does a couple of things:</p>
<ol>
<li>Automatically generates your proxy classes</li>
<li>Uses <code>ArrayCache</code>; a non-persistent caching class</li>
</ol>
<p>Likewise, when <code>$dev_mode</code> is false:</p>
<ol>
<li>Prevents your proxy classes from being overwritten</li>
<li>Attempts to use one of the following persistent caches, in this order: APC, Xcache, Memcache (127.0.0.1:11211), and Redis (127.0.0.1:6379)</li>
</ol>
<h2>Advanced Configuration</h2>
<p>For more advanced configuration, read the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/configuration.html">Configuration</a> section of the Doctrine documentation.</p>
<h2>Loading Doctrine</h2>
<p>Doctrine can now be loaded in the same way as any other CodeIgniter library:</p>
<pre class="highlight-php">$this-&gt;load-&gt;library('doctrine');</pre>
<p>Once the Doctrine library is loaded, you can retrieve the Entity Manage like so:</p>
<pre class="highlight-php">$em = $this-&gt;doctrine-&gt;em;</pre>
<h2>Defining Models</h2>
<p>Building models using the AnnotationDriver is simple. You can build your classes as if they were regular PHP classes, and define the Doctrine metadata in Docblock annotations.</p>
<pre class="highlight-php">&lt;?php

namespace Entity;

/**
 * @Entity
 * @Table(name="user")
 */
class User
{
     // ...
}</pre>
<p>The <code>@Entity</code> annotation marks this class for <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/basic-mapping.html#persistent-classes">object-relational persistence</a>. If the table name is not specified (using the <code>@Table</code> annotation), Doctrine will create a table with the same name as the class.</p>
<p>Annotations that you will probably use frequently are:</p>
<ul>
<li><code>@Column</code> – Marks a property for object-relational persistence</li>
<li><code>@OneToOne</code>, <code>@ManyToOne</code> and <code>@ManyToMany</code> – Define a relationship between two entities</li>
<li><code>@JoinTable</code> – Used when defining a <code>@ManyToMany</code> relationship to specify the database join table</li>
</ul>
<p>For a full list of the available annotations and their uses, see the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/annotations-reference.html">Annotation Reference</a></p>
<p>Below are two sample entities that show a basic one-to-many relationship:</p>
<pre class="highlight-php">&lt;?php

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
}</pre>
<p>It is important to note that any mapped properties on your Entities need to be either <code>private</code> or <code>protected</code>, otherwise <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/architecture.html#entities">lazy-loading might not work as expected</a>. This means that it is necessary to use Java-styled getter and setter methods:</p>
<pre class="highlight-php">public function setUsername($username)
{
    $this-&gt;username = $username;
}

public function getUsername()
{
    return $this-&gt;username;
}</pre>
<p>Thankfully you can save a lot of time and <a href="https://wildlyinaccurate.com/useful-doctrine-2-console-commands#orm-generate-entities">automatically generate these methods</a> using the <code>orm:generate-entities</code> command.</p>
<h2>Setting up the Doctrine Console</h2>
<p>This step is optional, however the Doctrine Console has some very useful commands so I highly recommend setting it up.</p>
<p>All you need to do is create the file application/doctrine.php and copy the following code into it:</p>
<pre class="highlight-php">&lt;?php

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

\Doctrine\ORM\Tools\Console\ConsoleRunner::run($helperSet);</pre>
<p>On a Linux or Mac, you can now run <code>./application/doctrine</code> from the command line.</p>
<p>If you are on Windows, you can run <code>php.exe application/doctrine.php</code> from the command line. If you are new to running PHP scripts from the command line in Windows, you may want to read <a href="http://php.net/manual/en/install.windows.commandline.php">PHP's documentation</a>.</p>
<h2>Using the Doctrine Console</h2>
<p>If you run the Doctrine console with no arguments, you will be presented with a list of the available commands. For now, we are only interested in the <code>orm:schema-tool</code> commands. If you would like to learn about the other commands you can run a command with the <code>--help</code> flag or read my quick <a href="https://wildlyinaccurate.com/useful-doctrine-2-console-commands">Doctrine console overview</a>.</p>
<p><strong>orm:schema-tool:create</strong> will create tables in your database based on your Doctrine models.</p>
<p><strong>orm:schema-tool:drop</strong> will do the exact opposite. It is worth noting that this command will only drop tables which have correlating Doctrine models. Any tables that aren't mapped to a Doctrine model will be left alone.</p>
<p><strong>orm:schema-tool:update</strong> will determine if your database schema is out-of-date, and give you the option of updating it. You can execute this command with the <code>--dump-sql</code> flag to see the changes, or the <code>--force</code> flag to execute the changes.</p>
<h2>Using Doctrine</h2>
<p>Once your models are set up and your database is built, you can access your models using the Doctrine EntityManager. I like shortcuts, so I always instantiate the EntityManager in MY_Controller:</p>
<pre class="highlight-php">&lt;?php

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
}</pre>
<p>Instead of the longer <code>$this-&gt;doctrine-&gt;em</code>, this will allow you to access the EntityManager using <code>$this-&gt;em</code>:</p>
<pre class="highlight-php">$user = new Entity\User;
$user-&gt;setUsername('Joseph');
$user-&gt;setPassword('secretPassw0rd');
$user-&gt;setEmail('josephatwildlyinaccuratedotcom');

$this-&gt;em-&gt;persist($user);
$this-&gt;em-&gt;flush();</pre>
<h2>Final Words</h2>
<p>If you have been spoiled by Doctrine 1's magic then you will probably have a hard time wrapping your head around Doctrine 2's strict object-oriented approach to everything. When learning your way around a new system, documentation can be your best friend or your worst enemy. Lucky for us, the Doctrine team has written some fantastic documentation. If you are having trouble getting something to work, one of the first things you should do is <abbr title="Read The Manual">RTFM</abbr> (<a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/index.html">Doctrine</a>; <a href="http://codeigniter.com/user_guide/">CodeIgniter</a>).</p>
<p>Good luck, I hope you enjoy using these powerful tools!</p>
