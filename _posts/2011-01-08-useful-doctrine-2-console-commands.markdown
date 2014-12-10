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

Doctrine 2's console is really powerful when you know how to use it. You can generate entity classes and their method stubs, reverse-engineer a database, validate your entity schemas, and much more. In this post, I'm going to cover some of the Doctrine console's more useful commands and explain how you can use them to reduce development time. For a full overview of the Doctrine 2 console, read the [Doctrine Tools](http://docs.doctrine-project.org/projects/doctrine-orm/en/latest/reference/tools.html) documentation.<!--more-->

## orm:validate-schema

Validate that your mapping files are correct and that your database is in sync. Not only does it ensure that your database is up-to-date, it finds errors in your mapping files, detects invalid entity relationships, and even warns you when your naming conventions are inconsistent.

Usage: `orm:validate-schema`

Example output:

<pre>[Mapping]  FAIL - The entity-class 'modelsAlbum' mapping is invalid:
* The mappings modelsAlbum#tracks and modelsSong#album are incosistent with each other.

[Mapping]  FAIL - The entity-class 'modelsGenre' mapping is invalid:
* The field modelsGenre#related_genres is on the owning side of a bi-directional relationship, but the specified mappedBy association on the target-entity modelsGenre#
does not contain the required 'inversedBy' attribute.

[Mapping]  FAIL - The entity-class 'modelsSong' mapping is invalid:
* The association modelsSong#album refers to the inverse side field modelsAlbum#songs which does not exist.

[Mapping]  FAIL - The entity-class 'modelsSongFile' mapping is invalid:
* The association modelsSongFile#downloads is ordered by a foreign field COUNT(id) that is not a field on the target entity modelsDownload

[Database] FAIL - The database schema is not in sync with the current mapping file.</pre>

## orm:convert-d1-schema

Convert a Doctrine 1 schema to Doctrine 2 format. This command can save you a lot of time and headaches when migrating projects from Doctrine 1 to Doctrine 2. The conversions I've tested are really accurate, but it would pay to check that everything looks okay after doing a conversion.

Usage: `orm:convert-d1-schema from-path to-type dest-path`

Example: `orm:convert-d1-schema models/d1-models annotation models`

In the above example, all of my Doctrine 1 schema files contained in `./models/d1-models` will be converted to Doctrine 2 annotation format and saved in `./models`. The original D1 schemas will not be modified.

## orm:convert-mapping

Convert your mapping information between different formats. There probably aren't many situations where you would need to convert your mapping information to a different format, but the feature that makes this command really useful is the `--from-database` flag. Using the `--from-database` flag allows you to essentially reverse-engineer a database by creating the mapping information from the database schema.

Usage: `orm:convert-mapping to-type dest-path`

Example: `orm:convert-mapping --from-database annotation models/generated`

The above example will read my database schema and create the entities with annotation mapping in my `./models/generated` directory. Omitting the `--from-database` flag would cause the command to read my existing mapping information and convert it to annotation format in the `./models/generated` directory.

## orm:generate-entities

Generate entity classes with getter and setter methods from your mapping information. The `--regenerate-entities="1"` flag will cause your entities to be re-generated even if they exist already. You can also use the `--generate-annotations` flag to automatically generate annotation metadata on your entities (only useful if your mapping information is not already in annotation format).

For a better idea of what this command can do, run `orm:generate-entities --help`.

Usage: `orm:generate-entities dest-path`

Example: `orm:generate-entities --generate-annotations="true" models/generated`

This example will read my mapping information and create the entity classes in `./models/generated`. It will also generate annotation metadata for my entity classes.
