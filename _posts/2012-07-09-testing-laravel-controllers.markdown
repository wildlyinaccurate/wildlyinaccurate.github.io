---
layout: post
title: Testing Laravel Controllers
date: 2012-07-09 23:53:26.000000000 +01:00
categories:
- Laravel
- Unit Testing
tags:
- controllers
- functional testing
- laravel
- unit testing
status: publish
type: post
published: true
author: Joseph Wynn
---
<p>There are a two main things that tripped me up while I was writing functional tests for my Laravel controllers: POST requests, and session state.</p>
<p>Laravel's Controller class has the <code>call()</code> method, which essentially makes a GET request to a controller method. In order to make POST requests, it's necessary to inject some extra parameters into the <code>HttpFoundation</code> components. To make this easier, I created a <code>ControllerTestCase</code> class with convenient <code>get()</code> and <code>post()</code> methods:<!--more--></p>
<pre class="highlight-php">abstract class ControllerTestCase extends PHPUnit_Framework_TestCase
{

    public function call($destination, $parameters = array(), $method = 'GET')
    {
        $old_method = Request::foundation()->getMethod();
        \Laravel\Request::foundation()-&gt;setMethod($method);
        $response = Controller::call($destination, $parameters);
        Request::foundation()-&gt;setMethod($old_method);

        return $response;
    }

    public function get($destination, $parameters = array())
    {
        return $this-&gt;call($destination, $parameters, 'GET');
    }

    public function post($destination, $post_data, $parameters = array())
    {
        $this-&gt;clean_request();
        \Laravel\Request::foundation()-&gt;request-&gt;add($post_data);

        return $this-&gt;call($destination, $parameters, 'POST');
    }

    private function clean_request()
    {
        $request = \Laravel\Request::foundation()-&gt;request;

        foreach ($request-&gt;keys() as $key)
        {
            $request-&gt;remove($key);
        }
    }

}</pre>
<p>Note that each POST request must be "cleaned" so that the POST data from previous requests isn't retained (thanks <a href="https://wildlyinaccurate.com/testing-laravel-controllers/comment-page-1#comment-4153">wahyudinata</a> for this tip!).</p>
<p>This makes it easy to write functional tests for Laravel controllers, for example checking the session for errors after a POST request:</p>
<pre class="highlight-php">require_once('ControllerTestCase.php');

class AccountControllerTest extends ControllerTestCase
{

    public function testSignupWithNoData()
    {
        $response = $this-&gt;post('account@signup', array());
        $this-&gt;assertEquals('302', $response-&gt;foundation-&gt;getStatusCode());

        $session_errors = \Laravel\Session::instance()-&gt;get('errors')-&gt;all();
        $this-&gt;assertNotEmpty($session_errors);
    }

    public function testSignupWithValidData()
    {
        $response = $this-&gt;post('account@signup', array(
            'username' =&gt; 'validusername',
            'email' =&gt; 'some@validemail.com',
            'password' =&gt; 'passw0rd',
            'password_confirm' =&gt; 'passw0rd',
        ));
        $this-&gt;assertEquals('302', $response-&gt;foundation-&gt;getStatusCode());

        $session_errors = \Laravel\Session::instance()-&gt;get('errors');
        $this-&gt;assertNull($session_errors);
    }

}</pre>
<p>But here is where the session state tripped me up. In <code>testSignupWithValidData</code>, the Laravel session state from <code>testSignupWithNoData</code> is retained and the test fails. To get around this, I simply reload the session before each test, in a <code>setUp</code> method in <code>ControllerTestCase</code>:</p>
<pre class="highlight-php">abstract class ControllerTestCase extends PHPUnit_Framework_TestCase
{

    // ...

    public function setUp()
    {
        \Laravel\Session::load();
    }

}</pre>
<p>And that's it! A fairly simple <code>ControllerTestCase</code> class which solves the POST request and session state problems. See this Gist for <a href="https://gist.github.com/3079291">the full code with comments</a>.</p>
