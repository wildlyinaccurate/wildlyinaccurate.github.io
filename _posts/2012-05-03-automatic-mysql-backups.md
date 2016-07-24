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

It's really easy to set up automatic MySQL backups using `mysqldump`. First, you need to set up a user with `SELECT` and `LOCK TABLES` privileges. In this example the user doesn't have a password.

```sql
CREATE USER 'autobackup'@'localhost';
GRANT SELECT, LOCK TABLES ON *.* TO 'autobackup'@'localhost';
```

Next create the cron job with `crontab -e`. This job is set to run every day at 5:20am.

```
20 5 * * * mysqldump --user=autobackup **dbname** | gzip -c > /var/backups/**dbname**-`/bin/date +\%Y\%m\%d`.sql.gz
```

Don't forget to change `dbname` to the name of the database that you want to backup. And that's it - you're done! This cron job will create a backup of your database and save it to `/var/backups` with a filename based on the current date, e.g. `/var/backups/**dbname**-20120503.sql.gz`
