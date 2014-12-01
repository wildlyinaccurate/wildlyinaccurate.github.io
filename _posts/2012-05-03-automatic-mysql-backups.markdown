---
layout: post
title: Automatic MySQL Backups
date: 2012-05-03 18:36:44.000000000 +01:00
categories:
- MySQL
- Server Administration
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>It's really easy to set up automatic MySQL backups using <code>mysqldump</code>. First, you need to set up a user with <code>SELECT</code> and <code>LOCK TABLES</code> privileges. In this example the user doesn't have a password.</p>
<pre class="highlight-sql">CREATE USER 'autobackup'@'localhost';
GRANT SELECT, LOCK TABLES ON *.* TO 'autobackup'@'localhost';</pre>
<p>Next create the cron job with <code>crontab -e</code>. This job is set to run every day at 5:20am.</p>
<pre>20 5 * * * mysqldump --user=autobackup <strong>dbname</strong> | gzip -c &gt; /var/backups/<strong>dbname</strong>-`/bin/date +\%Y\%m\%d`.sql.gz</pre>
<p>Don't forget to change <strong>dbname</strong> to the name of the database that you want to backup. And that's it - you're done! This cron job will create a backup of your database and save it to <code>/var/backups</code> with a filename based on the current date, e.g. <code>/var/backups/<strong>dbname</strong>-20120503.sql.gz</code></p>
