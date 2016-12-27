---
layout: post
title: Blazing fast WordPress with Nginx and Memcached
date: 2013-05-20 14:18:09.000000000 +01:00
categories:
- Server Administration
- Web Development
tags:
- memcached
- nginx
- php-fpm
- wordpress
status: publish
type: post
published: true
author: Joseph Wynn
extra_head:
  - <link rel="stylesheet" href="/css/highlight.css">
---

Inspired by Eric Mann's post on [caching WordPress with Redis](http://eamann.com/tech/ludicrous-speed-wordpress-caching-with-redis/), I thought I'd experiment with a similar setup using Memcached. Any in-memory caching system should work just as well, but I've chosen Memcached because it's already running on my server and because PHP already has a [built-in libmemcached API](http://www.php.net/manual/en/class.memcached.php).

My current setup is Nginx and PHP-FPM, with WP Super Cache. The cache is saved to the filesystem, allowing Nginx to serve static files (which it is [very good at](http://nbonvin.wordpress.com/2011/03/14/apache-vs-nginx-vs-varnish-vs-gwan/)) without needing to pass any requests to PHP. This setup has worked very well, so I'll be using it as a baseline.

To use Memcached, every request needs to be passed to PHP. My gut feeling was that this would be slower than serving static files with Nginx due to the overhead of spinning up a PHP process for each request.

## Benchmarks

To find out which of the two setups was faster, I measured the following metrics using [WebPagetest](http://www.webpagetest.org/) and [Blitz](http://www.blitz.io/bhm0Fw2xDFNoGcFXNKJaQSu) <small>(referral link)</small>:

*   Time To First Byte (although CloudFlare has speculated that [TTFB is a meaningless metric](http://blog.cloudflare.com/ttfb-time-to-first-byte-considered-meaningles))
*   Average response time
*   Average hit rate

<!--more-->

### Nginx + WPSC

```
TTFB            0.244 seconds
Response Time   310 ms
Hit Rate        89 hits/second
```

{% responsive_image path: assets/nginx-wpsc.png alt: "Nginx + WPSC" url: https://www.blitz.io/report/ecce61c2da008b383a5640d7f76593e7 %}

### Nginx + PHP-FPM + Memcached

```
TTFB            0.126 seconds
Response Time   241 ms
Hit Rate        94 hits/second
```

{% responsive_image path: assets/nginx-memcached.png alt: "Nginx + PHP-FPM + Memcached" url: https://www.blitz.io/report/ecce61c2da008b383a5640d7f7857f5b %}

## Conclusions

While the difference between the two setups isn't huge, the Memcached setup still came out noticeably faster with nearly half the TTFB and a 70ms faster response time. It also managed to serve 5 hits/second more than the WPSC setup.

## The Setup

If you want to try out this setup for yourself, it's relatively simple to get running.

First you'll need to create the PHP script that handles the caching. I've called mine `index-cached.php`. The script below will cache pages with the key `fullpage:your.domain.com/the/page/uri` for 1 day. It will also append a comment to the end of the response, specifying whether the page was served from cache or generated dynamically and how long the execution took.

```php
<?php

$start = microtime(true);

$memcached = new Memcached;
$memcached->addServer('127.0.0.1', 11211);

// Cache time in seconds (1 day)
$cacheTime = 60 * 60 * 24 * 1;
$cacheKey = "fullpage:{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";

$debugMessage = 'Page retrieved from cache in %f seconds';
$html = $memcached->get($cacheKey);

if ( ! $html) {
    $debugMessage = 'Page generated in %f seconds';

    ob_start();

    require 'index.php';
    $html = ob_get_contents();

    $memcached->set($cacheKey, $html, $cacheTime);

    ob_end_clean();
}

$finish = microtime(true);

echo $html;
echo '<!-- ' . sprintf($debugMessage, $finish - $start) . ' -->';
exit;
```

You also need to modify your Nginx site configuration to use this new script instead of the usual `index.php`. The configuration below is an example of how to do this. **It is not a fully-working site configuration**.

The important things to notice are:

*   If we determine that the current request can be cached, we set `index` to index-cached.php.
*   The cache isn't used if the request is from a mobile browser, if any login cookies are found, or if there are any query arguments.
*   The cache isn't used for the admin panel (/wp-admin).

```nginx
server {
    server_name yourdomain.com;
    root /var/www/yourdomain;
    error_page 404 = /index.php;

    set $cache_flags "";

    # Is this a mobile browser?
    if ($http_user_agent ~* "(2.0 MMP|240x320|400X240|AvantGo|BlackBerry|Blazer|Cellphone|Danger|DoCoMo|Elaine/3.0|EudoraWeb|Googlebot-Mobile|hiptop|IEMobile|KYOCERA/WX310K|LG/U990|MIDP-2.|MMEF20|MOT-V|NetFront|Newt|Nintendo Wii|Nitro|Nokia|Opera Mini|Palm|PlayStation Portable|portalmmm|Proxinet|ProxiNet|SHARP-TQ-GX10|SHG-i900|Small|SonyEricsson|Symbian OS|SymbianOS|TS21i-10|UP.Browser|UP.Link|webOS|Windows CE|WinWAP|YahooSeeker/M1A1-R2D2|NF-Browser|iPhone|iPod|Mobile|BlackBerry9530|G-TU915 Obigo|LGE VX|webOS|Nokia5800)" ) {
        set $cache_flags "{$cache_flags}M";
    }

    # Is the user logged in?
    if ($http_cookie ~* "(comment_author_|wordpress_logged_in_|wp-postpass_)" ) {
        set $cache_flags "${cache_flags}C";
    }

    # Do we have query arguments?
    if ($is_args) {
        set $cache_flags "${cache_flags}Q";
    }

    # If none of the rules above were matched, we can use the cache
    if ($cache_flags = "") {
        set $index_file /index-cached.php;
    }

    # Otherwise we'll just use index.php
    if ($cache_flags != "") {
        set $index_file /index.php;
    }

    location / {
        index $index_file index.html;
        try_files $uri $uri/ $index_file?$args;
    }

    # Force /wp-admin requests to always use index.php
    location /wp-admin/ {
        index index.php;
        try_files $uri $uri/ /index.php?$args;
    }

    # Pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    location ~ \.php$ {
        try_files $uri =404;
        include fastcgi_params;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass 127.0.0.1:9000;
    }
}
```

## Future Plans

This setup is inherently flawed in that it won't be able to stand up to a large traffic spike. This is because every single request needs to go through PHP-FPM. With enough traffic, PHP-FPM will eventually be unable to spawn enough processes to handle every request.

The next step in caching would be to put a reverse-proxy like [Varnish](https://www.varnish-cache.org/) in front of Nginx. This (in theory) should allow the server to handle massive spikes in traffic because none of the requests would have to go through PHP-FPM.

Another option would be to use a content delivery network like [CloudFlare](https://www.cloudflare.com/), which would be able to offload the majority of traffic to the site.

**Update: I've run the benchmarks with CloudFlare. Here are the results:**

```
TTFB            0.188 seconds
Response Time   131 ms
Hit Rate        101 hits/second
```

{% responsive_image path: assets/cloudflare.png alt: "CloudFlare" %}

The numbers seem impressive, but the graphs generated by Blitz show that the response times vary quite dramatically. I've also used CloudFlare in the past and found that the TTFB isn't always as low as this. This is part of the reason I stopped using CloudFlare; while synthetic benchmarks make it look fast, I found that average load actually times went up ...But that's a story for another blog post.
