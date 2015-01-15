---
layout: post
title: Using SSH agent forwarding with Vagrant
date: 2013-08-01 11:18:35.000000000 +01:00
categories:
- Server Administration
- Vagrant
tags:
- ssh
- vagrant
status: publish
type: post
published: true
author: Joseph Wynn
---

Sometimes you'll want to use your local SSH keys on your Vagrant boxes, so that you don't have to manage password-less keys for each box. This can be done with SSH agent forwarding, which is [explained in great detail on Unixwiz.net](http://www.unixwiz.net/techtips/ssh-agent-forwarding.html).

Setting this up is fairly straightforward. On the host machine, you need to add the following to `~/.ssh/config` (which you should create if it doesn't exist):

```
host your.domain.com
    ForwardAgent yes
```

You need to replace `your.domain.com` with either the domain or the IP address of your Vagrant box. You can wildcard this with `host *`, but this is a _really_ bad idea because it lets every server you SSH to access your keys.

Once you've done that, just run `ssh-add` to ensure you ensure your identities are added to the SSH agent.

Now, add the following to the config block in your Vagrantfile:

```ruby
config.ssh.forward_agent = true
```

That's all it takes. You can make sure it worked by comparing the output of `ssh-add -L` on both the host machine and the guest box.
