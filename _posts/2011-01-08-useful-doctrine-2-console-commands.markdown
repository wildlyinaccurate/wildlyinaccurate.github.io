---
layout: post
title: Useful Doctrine 2 Console Commands
date: 2011-01-08 17:50:00.000000000 +00:00
categories:
- Doctrine
- Web Development
tags:
- commands
- console
- Doctrine
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>Doctrine 2's console is really powerful when you know how to use it. You can generate entity classes and their method stubs, reverse-engineer a database, validate your entity schemas, and much more. In this post, I'm going to cover some of the Doctrine console's more useful commands and explain how you can use them to reduce development time. For a full overview of the Doctrine 2 console, read the <a href="http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/tools.html">Doctrine Tools</a> documentation.<!--more--></p>
<h2 id="orm-validate-schema">orm:validate-schema</h2>
<p>Validate that your mapping files are correct and that your database is in sync. Not only does it ensure that your database is up-to-date, it finds errors in your mapping files, detects invalid entity relationships, and even warns you when your naming conventions are inconsistent.</p>
<p>Usage: <code>orm:validate-schema</code><br />
Example output:</p>
<pre class="no-highlight">[Mapping]  FAIL - The entity-class 'modelsAlbum' mapping is invalid:
* The mappings modelsAlbum#tracks and modelsSong#album are incosistent with each other.

[Mapping]  FAIL - The entity-class 'modelsGenre' mapping is invalid:
* The field modelsGenre#related_genres is on the owning side of a bi-directional relationship, but the specified mappedBy association on the target-entity modelsGenre#
does not contain the required 'inversedBy' attribute.

[Mapping]  FAIL - The entity-class 'modelsSong' mapping is invalid:
* The association modelsSong#album refers to the inverse side field modelsAlbum#songs which does not exist.

[Mapping]  FAIL - The entity-class 'modelsSongFile' mapping is invalid:
* The association modelsSongFile#downloads is ordered by a foreign field COUNT(id) that is not a field on the target entity modelsDownload

[Database] FAIL - The database schema is not in sync with the current mapping file.</pre>
<h2 id="orm-convert-d1-schema">orm:convert-d1-schema</h2>
<p>Convert a Doctrine 1 schema to Doctrine 2 format. This command can save you a lot of time and headaches when migrating projects from Doctrine 1 to Doctrine 2. The conversions I've tested are really accurate, but it would pay to check that everything looks okay after doing a conversion.</p>
<p>Usage: <code>orm:convert-d1-schema from-path to-type dest-path</code><br />
Example: <code>orm:convert-d1-schema models/d1-models annotation models</code></p>
<p>In the above example, all of my Doctrine 1 schema files contained in <code>./models/d1-models</code> will be converted to Doctrine 2 annotation format and saved in <code>./models</code>. The original D1 schemas will not be modified.</p>
<h2 id="orm-convert-mapping">orm:convert-mapping</h2>
<p>Convert your mapping information between different formats. There probably aren't many situations where you would need to convert your mapping information to a different format, but the feature that makes this command really useful is the <code>--from-database</code> flag. Using the <code>--from-database</code> flag allows you to essentially reverse-engineer a database by creating the mapping information from the database schema.</p>
<p>Usage: <code>orm:convert-mapping to-type dest-path</code><br />
Example: <code>orm:convert-mapping --from-database annotation models/generated</code></p>
<p>The above example will read my database schema and create the entities with annotation mapping in my <code>./models/generated</code> directory. Omitting the <code>--from-database</code> flag would cause the command to read my existing mapping information and convert it to annotation format in the <code>./models/generated</code> directory.</p>
<h2 id="orm-generate-entities">orm:generate-entities</h2>
<p>Generate entity classes with getter and setter methods from your mapping information. The <code>--regenerate-entities="1"</code> flag will cause your entities to be re-generated even if they exist already. You can also use the <code>--generate-annotations</code> flag to automatically generate annotation metadata on your entities (only useful if your mapping information is not already in annotation format).</p>
<p>For a better idea of what this command can do, run <code>orm:generate-entities --help</code>.</p>
<p>Usage: <code>orm:generate-entities dest-path</code><br />
Example: <code>orm:generate-entities --generate-annotations="true" models/generated</code></p>
<p>This example will read my mapping information and create the entity classes in <code>./models/generated</code>. It will also generate annotation metadata for my entity classes.</p>
