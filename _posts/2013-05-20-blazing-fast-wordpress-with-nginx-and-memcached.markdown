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
---
<p>Inspired by Eric Mann's post on <a href="http://eamann.com/tech/ludicrous-speed-wordpress-caching-with-redis/">caching WordPress with Redis</a>, I thought I'd experiment with a similar setup using Memcached. Any in-memory caching system should work just as well, but I've chosen Memcached because it's already running on my server and because PHP already has a <a href="http://www.php.net/manual/en/class.memcached.php">built-in libmemcached API</a>.</p>
<p>My current setup is Nginx and PHP-FPM, with WP Super Cache. The cache is saved to the filesystem, allowing Nginx to serve static files (which it is <a href="http://nbonvin.wordpress.com/2011/03/14/apache-vs-nginx-vs-varnish-vs-gwan/">very good at</a>) without needing to pass any requests to PHP. This setup has worked very well, so I'll be using it as a baseline.</p>
<p>To use Memcached, every request needs to be passed to PHP. My gut feeling was that this would be slower than serving static files with Nginx due to the overhead of spinning up a PHP process for each request.</p>
<h2>Benchmarks</h2>
<p>To find out which of the two setups was faster, I measured the following metrics using <a href="http://www.webpagetest.org/">WebPagetest</a> and <a href="http://www.blitz.io/bhm0Fw2xDFNoGcFXNKJaQSu">Blitz</a> <small>(referral link)</small>:</p>
<ul>
<li>Time To First Byte (although CloudFlare has speculated that <a href="http://blog.cloudflare.com/ttfb-time-to-first-byte-considered-meaningles">TTFB is a meaningless metric</a>)</li>
<li>Average response time</li>
<li>Average hit rate</li>
</ul>
<p><!--more--></p>
<h3>Nginx + WPSC</h3>
<pre class="no-highlight">TTFB            0.244 seconds
Response Time   310 ms
Hit Rate        89 hits/second</pre>
<p><a href="https://www.blitz.io/report/ecce61c2da008b383a5640d7f76593e7"><img class="aligncenter size-full wp-image-730" src="assets/nginx-wpsc.png" alt="Nginx + WPSC" width="950" height="723" /></a></p>
<h3>Nginx + PHP-FPM + Memcached</h3>
<pre class="no-highlight">TTFB            0.126 seconds
Response Time   241 ms
Hit Rate        94 hits/second</pre>
<p><a href="https://www.blitz.io/report/ecce61c2da008b383a5640d7f7857f5b"><img class="aligncenter size-full wp-image-729" src="assets/nginx-memcached.png" alt="Nginx + PHP-FPM + Memcached" width="950" height="723" /></a></p>
<h2>Conclusions</h2>
<p>While the difference between the two setups isn't huge, the Memcached setup still came out noticeably faster with nearly half the TTFB and a 70ms faster response time. It also managed to serve 5 hits/second more than the WPSC setup.</p>
<h2>The Setup</h2>
<p>If you want to try out this setup for yourself, it's relatively simple to get running.</p>
<p>First you'll need to create the PHP script that handles the caching. I've called mine <code>index-cached.php</code>. The script below will cache pages with the key <code>fullpage:your.domain.com/the/page/uri</code> for 1 day. It will also append a comment to the end of the response, specifying whether the page was served from cache or generated dynamically and how long the execution took.</p>
<pre class="highlight-php">&lt;?php

$start = microtime(true);

$memcached = new Memcached;
$memcached-&gt;addServer('127.0.0.1', 11211);

// Cache time in seconds (1 day)
$cacheTime = 60 * 60 * 24 * 1;
$cacheKey = "fullpage:{$_SERVER['HTTP_HOST']}{$_SERVER['REQUEST_URI']}";

$debugMessage = 'Page retrieved from cache in %f seconds';
$html = $memcached-&gt;get($cacheKey);

if ( ! $html) {
    $debugMessage = 'Page generated in %f seconds';

    ob_start();

    require 'index.php';
    $html = ob_get_contents();

    $memcached-&gt;set($cacheKey, $html, $cacheTime);

    ob_end_clean();
}

$finish = microtime(true);

echo $html;
echo '&lt;!-- ' . sprintf($debugMessage, $finish - $start) . ' --&gt;';
exit;</pre>
<p>You also need to modify your Nginx site configuration to use this new script instead of the usual <code>index.php</code>. The configuration below is an example of how to do this. <strong>It is not a fully-working site configuration</strong>.</p>
<p>The important things to notice are:</p>
<ul>
<li>If we determine that the current request can be cached, we set <code>index</code> to index-cached.php.</li>
<li>The cache isn't used if the request is from a mobile browser, if any login cookies are found, or if there are any query arguments.</li>
<li>The cache isn't used for the admin panel (/wp-admin).</li>
</ul>
<pre class="highlight-nginx">server {
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
}</pre>
<h2>Future Plans</h2>
<p>This setup is inherently flawed in that it won't be able to stand up to a large traffic spike. This is because every single request needs to go through PHP-FPM. With enough traffic, PHP-FPM will eventually be unable to spawn enough processes to handle every request.</p>
<p>The next step in caching would be to put a reverse-proxy like <a href="https://www.varnish-cache.org/">Varnish</a> in front of Nginx. This (in theory) should allow the server to handle massive spikes in traffic because none of the requests would have to go through PHP-FPM.</p>
<p>Another option would be to use a content delivery network like <a href="https://www.cloudflare.com/">CloudFlare</a>, which would be able to offload the majority of traffic to the site.</p>
<p><strong>Update: I've run the benchmarks with CloudFlare. Here are the results:</strong></p>
<pre class="no-highlight">TTFB            0.188 seconds
Response Time   131 ms
Hit Rate        101 hits/second</pre>
<p><a href="https://wildlyinaccurate.com/wp-content/uploads/2013/05/cloudflare.png"><img class="aligncenter size-full wp-image-757" src="assets/cloudflare.png" alt="CloudFlare" width="950" height="723" /></a></p>
<p>The numbers seem impressive, but the graphs generated by Blitz show that the response times vary quite dramatically. I've also used CloudFlare in the past and found that the TTFB isn't always as low as this. This is part of the reason I stopped using CloudFlare; while synthetic benchmarks make it look fast, I found that average load actually times went up ...But that's a story for another blog post.</p>
