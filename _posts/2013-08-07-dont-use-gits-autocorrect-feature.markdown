---
layout: post
title: Don't use Git's autocorrect feature
date: 2013-08-07 15:40:12.000000000 +01:00
categories:
- Git
tags:
- autocorrect
- git
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
<p>Quite often I've accidentally typed "git" twice. Usually this is fine, and Git just does something like this:</p>
<pre class="no-highlight">$ git git diff
git: 'git' is not a git command. See 'git --help'.

Did you mean this?
    init</pre>
<p>But I recently turned on Git's autocorrect feature, to see what it was like (<code>git config --global help.autocorrect 1</code>). The results were... <em>interesting</em>:</p>
<pre class="no-highlight">$ git git diff
WARNING: You called a Git command named 'git', which does not exist.
Continuing under the assumption that you meant 'init' in <strong>0.1 seconds</strong> automatically...
fatal: internal error: work tree has already been set
Current worktree: /nfs/personaldev/vagrant/mobileweb-v2
New worktree: /nfs/personaldev/vagrant/mobileweb-v2/diff</pre>
<p>This is really bizarre behaviour. The fact that it wants to autocorrect it to <code>git init</code> is <em>sort-of</em> okay. But rather than giving me the option to confirm that this is what I want, Git gives me a whole <strong>0.1 seconds</strong> to hit Ctrl+C before it automatically runs the command for me.</p>
<p>Thankfully, <code>git init</code> isn't a very destructive command. I was lucky that the only side effect of this was that Git created a new directory called <code>diff</code>. I can't help but wonder what would've happened if Git decided to autocorrect to a more destructive command like <code>reset</code>, <code>checkout</code>, or <code>gc</code>.</p>
<p>The lesson here? Don't use Git's autocorrect. It really sucks.</p>
<p>Update: m_bright pointed out that the value of <code>help.autocorrect</code> is actually how many tenths of a second Git will wait before automatically executing the command. So something like <code>git config --global help.autocorrect 10</code> would give you 1 second before the command is executed, which is probably slow enough to let you cancel any mistakes, and quick enough to still be useful.</p>
