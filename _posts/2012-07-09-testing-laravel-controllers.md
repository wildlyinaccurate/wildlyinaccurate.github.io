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

There are a two main things that tripped me up while I was writing functional tests for my Laravel controllers: POST requests, and session state.

Laravel's Controller class has the `call()` method, which essentially makes a GET request to a controller method. In order to make POST requests, it's necessary to inject some extra parameters into the `HttpFoundation` components. To make this easier, I created a `ControllerTestCase` class with convenient `get()` and `post()` methods:<!--more-->

```php
abstract class ControllerTestCase extends PHPUnit_Framework_TestCase
{

    public function call($destination, $parameters = array(), $method = 'GET')
    {
        $old_method = Request::foundation()->getMethod();
        \Laravel\Request::foundation()->setMethod($method);
        $response = Controller::call($destination, $parameters);
        Request::foundation()->setMethod($old_method);

        return $response;
    }

    public function get($destination, $parameters = array())
    {
        return $this->call($destination, $parameters, 'GET');
    }

    public function post($destination, $post_data, $parameters = array())
    {
        $this->clean_request();
        \Laravel\Request::foundation()->request->add($post_data);

        return $this->call($destination, $parameters, 'POST');
    }

    private function clean_request()
    {
        $request = \Laravel\Request::foundation()->request;

        foreach ($request->keys() as $key)
        {
            $request->remove($key);
        }
    }

}
```

Note that each POST request must be "cleaned" so that the POST data from previous requests isn't retained (thanks [wahyudinata](https://wildlyinaccurate.com/testing-laravel-controllers/comment-page-1#comment-4153) for this tip!).

This makes it easy to write functional tests for Laravel controllers, for example checking the session for errors after a POST request:

```php
require_once('ControllerTestCase.php');

class AccountControllerTest extends ControllerTestCase
{

    public function testSignupWithNoData()
    {
        $response = $this->post('account@signup', array());
        $this->assertEquals('302', $response->foundation->getStatusCode());

        $session_errors = \Laravel\Session::instance()->get('errors')->all();
        $this->assertNotEmpty($session_errors);
    }

    public function testSignupWithValidData()
    {
        $response = $this->post('account@signup', array(
            'username' => 'validusername',
            'email' => 'some@validemail.com',
            'password' => 'passw0rd',
            'password_confirm' => 'passw0rd',
        ));
        $this->assertEquals('302', $response->foundation->getStatusCode());

        $session_errors = \Laravel\Session::instance()->get('errors');
        $this->assertNull($session_errors);
    }

}
```

But here is where the session state tripped me up. In `testSignupWithValidData`, the Laravel session state from `testSignupWithNoData` is retained and the test fails. To get around this, I simply reload the session before each test, in a `setUp` method in `ControllerTestCase`:

```php
abstract class ControllerTestCase extends PHPUnit_Framework_TestCase
{

    // ...

    public function setUp()
    {
        \Laravel\Session::load();
    }

}
```

And that's it! A fairly simple `ControllerTestCase` class which solves the POST request and session state problems. See this Gist for [the full code with comments](https://gist.github.com/3079291).
