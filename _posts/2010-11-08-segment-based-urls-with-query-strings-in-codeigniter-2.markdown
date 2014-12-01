---
layout: post
title: Segment-Based URLs with Query Strings in CodeIgniter 2
date: 2010-11-08 22:31:43.000000000 +00:00
categories:
- CodeIgniter
- PHP
- Web Development
tags: []
status: publish
type: post
published: true
author: Joseph Wynn
---

My latest CodeIgniter 2 project requires that I use query strings in some of my URLs. CodeIgniter 1 was notoriously difficult to work with when you enabled query strings, and unfortunately CodeIgniter 2 is no different. Whereas in CodeIgniter 1 you could change two configuration options to enable a combination of segment-based URLs and query strings, this same approach only makes matters worse in CodeIgniter 2.

<!--more-->

<pre>$config['uri_protocol'] = "PATH_INFO";
$config['enable_query_strings'] = TRUE;</pre>

You would expect that using this configuration would allow you to use query strings, while still using the PATH_INFO URI protocol for your segment-based URLs. In CodeIgniter 1 this would produce URLs like `example.com/users/profile?user=Joseph&edit=true`. CodeIgniter 2 however would produce `example.com/?users/profile?user=Joseph&edit=true` - and the reason for this becomes apparent when you compare CodeIgniter 2's CI_Config::site_url() method with the same method in CodeIgniter 1.

I'm sure their intentions were good, but it appears that the CodeIgniter team assumes that if you enable query strings, you will not use segment-based URLs. Based on this assumption, the site_url() method appends a question mark (?) to the end of your base_url.

Getting around this is a very simple task; only one line needs to be modified. In `system/core/Config.php`, change line 221 from:

<pre>if ($this-&gt;item('enable_query_strings') == FALSE)</pre>

To:

<pre>if ($this-&gt;item('enable_query_strings') == FALSE OR $this-&gt;item('uri_protocol') == 'PATH_INFO')</pre>

And there you have it. Setting uri_protocol to PATH_INFO and enabling query strings will allow you to have  attractive segment-based URLs and still make use of query strings.

Note: It is considered good practice to extend core classes rather than modify them. I highly recommend doing this, as it will prevent your changes from being overwritten when you update CodeIgniter. To extend the CI_Config class, create the file `application/core/MY_Config.php` and paste the following code into it:

<pre class="highlight-php">class MY_Config extends CI_Config
{
    /**
     * Site URL
     *
     * Extended to allow a combination segment-based URLs and query strings when using the
     * uri_protocol = PATH_INFO / enable_query_strings = TRUE configuration setting.
     *
     * @access    public
     * @param    string    the URI string
     * @return    string
     */
    function site_url($uri = '')
    {
        if ($uri == '')
        {
            if ($this->item('base_url') == '')
            {
                return $this->item('index_page');
            }
            else
            {
                return $this->slash_item('base_url').$this->item('index_page');
            }
        }

        if ($this->item('enable_query_strings') == FALSE OR $this->item('uri_protocol') == 'PATH_INFO')
        {
            if (is_array($uri))
            {
                $uri = implode('/', $uri);
            }

            $suffix = ($this->item('url_suffix') == FALSE) ? '' : $this->item('url_suffix');
            return $this->slash_item('base_url').$this->slash_item('index_page').trim($uri, '/').$suffix;
        }
        else
        {
            if (is_array($uri))
            {
                $i = 0;
                $str = '';
                foreach ($uri as $key => $val)
                {
                    $prefix = ($i == 0) ? '' : '&';
                    $str .= $prefix.$key.'='.$val;
                    $i++;
                }

                $uri = $str;
            }

            if ($this->item('base_url') == '')
            {
                return $this->item('index_page').'?'.$uri;
            }
            else
            {
                return $this->slash_item('base_url').$this->item('index_page').'?'.$uri;
            }
        }
    }
}</pre>
