---
layout: post
title: HTTP status as a service
date: 2013-09-30 15:13:22.000000000 +01:00
categories:
- JavaScript
- Web Development
tags:
- http status code
- node.js
- service
status: publish
type: post
published: true
author:
  login: joseph
  email: joseph@wildlyinaccurate.com
  display_name: Joseph
  first_name: Joseph
  last_name: Wynn
---
<p>Using Node.js* you can run a simple "HTTP status as a service" server. This can be useful for quickly checking whether your application handles various status codes.</p>
<pre class="highlight-javascript">var http = require('http');

http.createServer(function (request, response) {
  var status = request.url.substr(1);

  if ( ! http.STATUS_CODES[status]) {
    status = '404';
  }

  response.writeHead(status, { 'Content-Type': 'text/plain' });
  response.end(http.STATUS_CODES[status]);
}).listen(process.env.PORT || 5000);</pre>
<p>This will create a server on port 5000, or any port that you specify in the <code>PORT</code> environment variable. It will respond to <code>/{CODE}</code> and return the HTTP status that corresponds to <code>{CODE}</code>. Here's a couple of examples:</p>
<pre class="no-highlight">$ curl -i http://127.0.0.1:5000/500
HTTP/1.1 500 Internal Server Error
Content-Type: text/plain
Date: Mon, 30 Sep 2013 14:10:10 GMT
Connection: keep-alive
Transfer-Encoding: chunked

Internal Server Error%</pre>
<pre class="no-highlight">$ curl -i http://127.0.0.1:5000/404
HTTP/1.1 404 Not Found
Content-Type: text/plain
Date: Mon, 30 Sep 2013 14:10:32 GMT
Connection: keep-alive
Transfer-Encoding: chunked

Not Found%</pre>
<p>This is a really simple example, and could easily be extended to let you specify a <code>Location</code> header value for 30X responses.</p>
<p><small>*Well, you could use anything really. I'm just using Node.js since JavaScript is my language of choice.</small></p>
