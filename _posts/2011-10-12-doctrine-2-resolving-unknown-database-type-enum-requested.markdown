---
layout: post
title: 'Doctrine 2: Resolving "unknown database type enum requested"'
date: 2011-10-12 20:13:12.000000000 +01:00
categories:
- Doctrine
- PHP
tags:
- Doctrine
- enum
status: publish
type: post
published: true
author: Joseph Wynn
---

I came across this recently while I was developing a module for PyroCMS. Some of the PyroCMS tables contain ENUM columns, which Doctrine doesn't support. You would think that this wouldn't be an issue since these tables are not mapped, but apparently when Doctrine builds the schema it includes all tables in the database - even if they are not mapped. This has been [reported as an issue](http://www.doctrine-project.org/jira/browse/DDC-1273), but the Doctrine team has given it a low priority.

The symptom? When using the SchemaTool to create, update, or drop the schema; an exception is thrown:

```
**Fatal error**: Uncaught exception 'Doctrine\DBAL\DBALException' with message 'Unknown database type enum requested, Doctrine\DBAL\Platforms\MySqlPlatform may not support it.'
```

Thankfully, the fix is very easy. There is even a [Doctrine Cookbook article](http://www.doctrine-project.org/docs/orm/2.1/en/cookbook/mysql-enums.html) about it. All you have to do is register the ENUM type as a Doctrine varchar (string):

```php
/** @var $em \Doctrine\ORM\EntityManager */
$platform = $em-&gt;getConnection()-&gt;getDatabasePlatform();
$platform-&gt;registerDoctrineTypeMapping('enum', 'string');
```

This fix can be applied to any unsupported data type, for example SET (which is also used in PyroCMS):

```php
$platform-&gt;registerDoctrineTypeMapping('set', 'string');
```
