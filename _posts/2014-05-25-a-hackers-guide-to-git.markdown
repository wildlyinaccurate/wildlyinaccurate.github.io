---
layout: post
title: A Hacker's Guide to Git
date: 2014-05-25 17:12:22.000000000 +01:00
categories:
- Git
tags:
- git
- merge
- rebase
status: publish
type: post
published: true
author: Joseph Wynn
---
<p><em>A Hacker's Guide to Git</em> is now available as an e-book. You can purchase it <a href="https://leanpub.com/a-hackers-guide-to-git">on LeanPub</a>.</p>
<p>[toc]</p>
<h2>Introduction</h2>
<p>Git is currently the most widely used version control system in the world, mostly thanks to GitHub. By that measure, I'd argue that it's also the most misunderstood version control system in the world.</p>
<p>This statement probably doesn't ring true straight away because on the surface, Git is pretty simple. It's really easy to pick up if you've come from another VCS like Subversion or Mercurial. It's even relatively easy to pick up if you've never used a VCS before. Everybody understands adding, committing, pushing and pulling; but this is about as far as Git's simplicity goes. Past this point, Git is shrouded by fear, uncertainty and doubt.</p>
<p>Once you start talking about branching, merging, rebasing, multiple remotes, remote-tracking branches, detached HEAD states... Git becomes less of an easily-understood tool and more of a feared deity. Anybody who talks about no-fast-forward merges is regarded with quiet superstition, and even veteran hackers would rather stay away from rebasing "just to be safe".</p>
<p>I think a big part of this is due to many people coming to Git from a conceptually simpler VCS -- probably Subversion -- and trying to apply their past knowledge to Git. It's easy to understand why people want to do this. Subversion is simple, right? It's just files and folders. Commits are numbered sequentially. Even branching and tagging is simple -- it's just like taking a backup of a folder.</p>
<p>Basically, Subversion fits in nicely with our existing computing paradigms. Everybody understands files and folders. Everybody knows that revision #10 was the one after #9 and before #11. But these paradigms break down when you try to apply them to Git.</p>
<p>That's why trying to understand Git in this way is wrong. Git doesn't work like Subversion at all. Which can be pretty confusing. You can add and remove files. You can commit your changes. You can generate diffs and patches which look just like the ones that Subversion generates. So how can something which appears so similar really be so different?</p>
<p>Complex systems like Git become much easier to understand once you figure out how they really work. The goal of this guide is to shed some light on how Git works under the hood. We're going to take a look at some of Git's core concepts including its basic object storage, how commits work, how branches and tags work, and we'll look at the different kinds of merging in Git including the much-feared rebase. Hopefully at the end of it all, you'll have a solid understanding of these concepts and will be able to use some of Git's more advanced features with confidence.</p>
<p>It's worth noting at this point that this guide is not intended to be a beginner's introduction to Git. This guide was written for people who already use Git, but would like to better understand it by taking a peek under the hood, and learn a few neat tricks along the way. With that said, let's begin.</p>
<p><!--more--></p>
<h2>Repositories</h2>
<p>At the core of Git, like other VCS, is the repository. A Git repository is really just a simple key-value data store. This is where Git stores, among other things:</p>
<ul>
<li><strong>Blobs</strong>, which are the most basic data type in Git. Essentially, a blob is just a bunch of bytes; usually a binary representation of a file.</li>
<li><strong>Tree objects</strong>, which are a bit like directories. Tree objects can contain pointers to blobs and other tree objects.</li>
<li><strong>Commit objects</strong>, which point to a single tree object, and contain some metadata including the commit author and any parent commits.</li>
<li><strong>Tag objects</strong>, which point to a single commit object, and contain some metadata.</li>
<li><strong>References</strong>, which are pointers to a single object (usually a commit or tag object).</li>
</ul>
<p>You don't need to worry about all of this just yet; we'll cover these things in more detail later.</p>
<p>The important thing to remember about a Git repository is that it exists entirely in a single <code>.git</code> directory in your project root. There is no central repository like in Subversion or CVS. This is what allows Git to be a <em>distributed</em> version control system -- everybody has their own self-contained version of a repository.</p>
<p>You can initialize a Git repository anywhere with the <code>git init</code> command. Take a look inside the <code>.git</code> folder to get a glimpse of what a repository looks like.</p>
<pre class="no-highlight">$ git init
Initialized empty Git repository in /home/demo/demo-repository/.git/
$ ls -l .git
total 32
drwxrwxr-x 2 demo demo 4096 May 24 20:10 branches
-rw-rw-r-- 1 demo demo 92 May 24 20:10 config
-rw-rw-r-- 1 demo demo 73 May 24 20:10 description
-rw-rw-r-- 1 demo demo 23 May 24 20:10 HEAD
drwxrwxr-x 2 demo demo 4096 May 24 20:10 hooks
drwxrwxr-x 2 demo demo 4096 May 24 20:10 info
drwxrwxr-x 4 demo demo 4096 May 24 20:10 objects
drwxrwxr-x 4 demo demo 4096 May 24 20:10 refs</pre>
<p>The important directories are <code>.git/objects</code>, where Git stores all of its objects; and <code>.git/refs</code>, where Git stores all of its references.</p>
<p>We'll see how all of this fits together as we learn about the rest of Git. For now, let's learn a little bit more about tree objects.</p>
<h2>Tree Objects</h2>
<p>A tree object in Git can be thought of as a directory. It contains a list of blobs (files) and other tree objects (sub-directories).</p>
<p>Imagine we had a simple repository, with a <code>README</code> file and a <code>src/</code> directory containing a <code>hello.c</code> file.</p>
<pre class="no-highlight">README
src/
    hello.c</pre>
<p>This would be represented by two tree objects: one for the root directory, and another for the <code>src/</code> directory. Here's what they would look like.</p>
<p><strong>tree 4da454..</strong></p>
<table border="1" cellpadding="8">
<tbody>
<tr>
<td>blob</td>
<td>976165..</td>
<td>README</td>
</tr>
<tr>
<td>tree</td>
<td>81fc8b..</td>
<td>src</td>
</tr>
</tbody>
</table>
<p><strong>tree 81fc8b..</strong></p>
<table border="1" cellpadding="8">
<tbody>
<tr>
<td>blob</td>
<td>1febef..</td>
<td>hello.c</td>
</tr>
</tbody>
</table>
<p>If we draw the blobs (in green) as well as the tree objects (in blue), we end up with a diagram that looks a lot like our directory structure.</p>
<p><img class="aligncenter size-full wp-image-1079" src="assets/tree-graph.png" alt="Git tree graph" width="591" height="458" /></p>
<p>Notice how given the root tree object, we can recurse through every tree object to figure out the state of the entire working tree. The root tree object, therefore, is essentially a snapshot of your repository at a given time. Usually when Git refers to "the tree", it is referring to the root tree object.</p>
<p>Now let's learn how you can track the history of your repository with commit objects.</p>
<h2>Commits</h2>
<p>A commit object is essentially a pointer that contains a few pieces of important metadata. The commit itself has a hash, which is built from a combination of the metadata that it contains:</p>
<ul>
<li>The hash of the tree (the root tree object) at the time of the commit. As we learned in <em>Tree Objects</em>, this means that with a single commit, Git can build the entire working tree by recursing into the tree.</li>
<li>The hash of any parent commits. This is what gives a repository its history: every commit has a parent commit, all the way back to the very first commit.</li>
<li>The author's name and email address, and the time that the changes were authored.</li>
<li>The committer's name and email address, and the time that the commit was made.</li>
<li>The commit message.</li>
</ul>
<p>Let's see a commit object in action by creating a simple repository.</p>
<pre class="no-highlight"> $ git init
Initialized empty Git repository in /home/demo/simple-repository/.git/
 $ echo 'This is the readme.' &gt; README
 $ git add README
 $ git commit -m "First commit"
[master (root-commit) <strong>d409ca7</strong>] First commit
 1 file changed, 1 insertion(+)
 create mode 100644 README</pre>
<p>When you create a commit, Git will give you the hash of that commit. Using <code>git show</code> with the <code>--format=raw</code> flag, we can see this newly-created commit's metadata.</p>
<pre class="no-highlight">$ git show --format=raw d409ca7

commit d409ca76bc919d9ca797f39ae724b7c65700fd27
tree 9d073fcdfaf07a39631ef94bcb3b8268bc2106b1
author Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400
committer Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400

    First commit

diff --git a/README b/README
new file mode 100644
index 0000000..9761654
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+This is the readme.
</pre>
<p>Notice how although we referenced the commit by the partial hash <code>d409ca7</code>, Git was able to figure out that we actually meant <code>d409ca76bc919d9ca797f39ae724b7c65700fd27</code>. This is because the hashes that Git assigns to objects are unique enough to be identified by the first few characters. You can see here that Git is able to find this commit with as few as four characters; after which point Git will tell you that the reference is ambiguous.</p>
<pre class="no-highlight">$ git show d409c
$ git show d409
$ git show d40
fatal: ambiguous argument 'd40': unknown revision or path not in the working tree.</pre>
<h2>References</h2>
<p>In previous sections, we saw how objects in Git are identified by a hash. Since we want to manipulate objects quite often in Git, it's important to know their hashes. You could run all your Git commands referencing each object's hash, like <code>git show d409ca7</code>, but that would require you to remember the hash of every object you want to manipulate.</p>
<p>To save you from having to memorize these hashes, Git has references, or "refs". A reference is simply a file stored somewhere in <code>.git/refs</code>, containing the hash of a commit object.</p>
<p>To carry on the example from <em>Commits</em>, let's figure out the hash of "First commit" using references only.</p>
<pre class="no-highlight">$ git status
On branch master
nothing to commit, working directory clean</pre>
<p><code>git status</code> has told us that we are on branch <code>master</code>. As we will learn in a later section, branches are just references. We can see this by looking in <code>.git/refs/heads</code>.</p>
<pre class="no-highlight">$ ls -l .git/refs/heads/
total 4
-rw-rw-r-- 1 demo demo 41 May 24 20:02 master</pre>
<p>We can easily see which commit <code>master</code> points to by reading the file.</p>
<pre class="no-highlight">$ cat .git/refs/heads/master
d409ca76bc919d9ca797f39ae724b7c65700fd27</pre>
<p>Sure enough, <code>master</code> contains the hash of the "First commit" object.</p>
<p>Of course, it's possible to simplify this process. Git can tell us which commit a reference is pointing to with the <code>show</code> and <code>rev-parse</code> commands.</p>
<pre class="no-highlight">$ git show --oneline master
d409ca7 First commit
$ git rev-parse master
d409ca76bc919d9ca797f39ae724b7c65700fd27</pre>
<p>Git also has a special reference, <code>HEAD</code>. This is a "symbolic" reference which points to the tip of the current branch rather than an actual commit. If we inspect <code>HEAD</code>, we see that it simply points to <code>refs/head/master</code>.</p>
<pre class="no-highlight">$ cat .git/HEAD
ref: refs/heads/master</pre>
<p>It is actually possible for <code>HEAD</code> to point directly to a commit object. When this happens, Git will tell you that you are in a "detached HEAD state". We'll talk a bit more about this later, but really all this means is that you're not currently on a branch.</p>
<h2>Branches</h2>
<p>Git's branches are often touted as being one of its strongest features. This is because branches in Git are very lightweight, compared to other VCS where a branch is usually a clone of the entire repository.</p>
<p>The reason branches are so lightweight in Git is because they're just references. We saw in <em>References</em> that the <code>master</code> branch was simply a file inside <code>.git/refs/heads</code>. Let's create another branch to see what happens under the hood.</p>
<pre class="no-highlight">$ git branch test-branch
$ cat .git/refs/heads/test-branch
d409ca76bc919d9ca797f39ae724b7c65700fd27</pre>
<p>It's as simple as that. Git has created a new entry in <code>.git/refs/heads</code> and pointed it at the current commit.</p>
<p>We also saw in <em>References</em> that <code>HEAD</code> is Git's reference to the current branch. Let's see that in action by switching to our newly-created branch.</p>
<pre class="no-highlight">$ cat .git/HEAD
ref: refs/heads/master
$ git checkout test-branch
Switched to branch 'test-branch'
$ cat .git/HEAD
ref: refs/heads/test-branch</pre>
<p>When you create a new commit, Git simply changes the current branch to point to the newly-created commit object.</p>
<pre class="no-highlight">$ echo 'Some more information here.' &gt;&gt; README
$ git add README
$ git commit -m "Update README in a new branch"
[test-branch 7604067] Update README in a new branch
 1 file changed, 1 insertion(+)
$ cat .git/refs/heads/test-branch
76040677d717fd090e327681064ac6af9f0083fb</pre>
<p>Later on we'll look at the difference between <strong>local branches</strong> and <strong>remote-tracking branches</strong>.</p>
<h2>Tags</h2>
<p>There are two types of tags in Git -- <strong>lightweight tags</strong> and <strong>annotated tags</strong>.</p>
<p>On the surface, these two types of tags look very similar. Both of them are references stored in <code>.git/refs/tags</code>. However, that's about as far as the similarities go. Let's create a lightweight tag to see how they work.</p>
<pre class="no-highlight">$ git tag 1.0-lightweight
$ cat .git/refs/tags/1.0-lightweight
d409ca76bc919d9ca797f39ae724b7c65700fd27</pre>
<p>We can see that Git has created a tag reference which points to the current commit. By default, <code>git tag</code> will create a lightweight tag. Note that this is <strong>not a tag object</strong>. We can verify this by using <code>git cat-file</code> to inspect the tag.</p>
<pre class="no-highlight">$ git cat-file -p 1.0-lightweight
tree 9d073fcdfaf07a39631ef94bcb3b8268bc2106b1
author Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400
committer Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400

First commit
$ git cat-file -p d409ca7
tree 9d073fcdfaf07a39631ef94bcb3b8268bc2106b1
author Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400
committer Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1400976134 -0400

First commit</pre>
<p>You can see that as far as Git is concerned, the <code>1.0-lightweight</code> tag and the <code>d409ca7</code> commit are the <em>same object</em>. That's because the lightweight tag is <em>only a reference</em> to the commit object.</p>
<p>Let's compare this to an annotated tag.</p>
<pre class="no-highlight">$ git tag -a -m "Tagged 1.0" 1.0
$ cat .git/refs/tags/1.0
10589beae63c6e111e99a0cd631c28479e2d11bf</pre>
<p>We've passed the <code>-a</code> (<code>--annotate</code>) flag to <code>git tag</code> to create an annotated tag. Notice how Git creates a reference for the tag just like the lightweight tag, but this reference is not pointing to the same object as the lightweight tag. Let's use <code>git cat-file</code> again to inspect the object.</p>
<pre class="no-highlight">$ git cat-file -p 1.0
object d409ca76bc919d9ca797f39ae724b7c65700fd27
type commit
tag 1.0
tagger Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1401029229 -0400

Tagged 1.0</pre>
<p>This is a <strong>tag object</strong>, separate to the commit that it points to. As well as containing a pointer to a commit, tag objects also store a tag message and information about the tagger. Tag objects can also be signed with a <a title="GNU Privacy Guard" href="http://en.wikipedia.org/wiki/GNU_Privacy_Guard">GPG key</a> to prevent commit or email spoofing.</p>
<p>Aside from being GPG-signable, there are a few reasons why annotated tags are preferred over lightweight tags.</p>
<p>Probably the most important reason is that annotated tags have their own author information. This can be helpful when you want to know who created the tag, rather than who created the commit that the tag is referring to.</p>
<p>Annotated tags are also timestamped. Since new versions are usually tagged right before they are released, an annotated tag can tell you when a version was released rather than just when the final commit was made.</p>
<h2>Merging</h2>
<p>Merging in Git is the process of joining two histories (usually branches) together. Let's start with a simple example. Say you've created a new feature branch from <code>master</code>, and done some work on it.</p>
<pre class="no-highlight">$ git checkout -b feature-branch
Switched to a new branch 'feature-branch'
$ vim feature.html
$ git commit -am "Finished the new feature"
[feature-branch 0c21359] Finished the new feature
 1 file changed, 1 insertion(+)</pre>
<p>At the same time, you need to fix an urgent bug. So you create a <code>hotfix</code> branch from <code>master</code>, and do some work in there.</p>
<pre class="no-highlight">$ git checkout master
Switched to branch 'master'
$ git checkout -b hotfix
Switched to a new branch 'hotfix'
$ vim index.html
$ git commit -am "Fixed some wording"
[hotfix 40837f1] Fixed some wording
 1 file changed, 1 insertion(+), 1 deletion(-)</pre>
<p>At this point, the history will look something like this.</p>
<p><img class="aligncenter size-full wp-image-1108" src="assets/branch-feature-hotfix.png" alt="Branching -- hotfix and feature branch" width="631" height="269" /></p>
<p>Now you want to bring the bug fix into <code>master</code> so that you can tag it and release it.</p>
<pre class="no-highlight">$ git checkout master
Switched to branch 'master'
$ git merge hotfix
Updating d939a3a..40837f1
Fast-forward
 index.html | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)</pre>
<p>Notice how Git mentions <strong>fast-forward</strong> during the merge. What this means is that all of the commits in <code>hotfix</code> were directly upstream from <code>master</code>. This allows Git to simply move the <code>master</code> pointer up the tree to <code>hotfix</code>. What you end up with looks like this.</p>
<p><img class="aligncenter size-full wp-image-1111" src="assets/branch-merge-hotfix.png" alt="Branching -- after merging hotfix" width="631" height="269" /></p>
<p>Now let's try and merge <code>feature-branch</code> into <code>master</code>.</p>
<pre class="no-highlight">$ git merge feature-branch
Merge made by the 'recursive' strategy.
 feature.html | 1 +
 1 file changed, 1 insertion(+)</pre>
<p>This time, Git wasn't able to perform a fast-forward. This is because <code>feature-branch</code> isn't directly upstream from <code>master</code>. This is clear on the graph above, where <code>master</code> is at commit <strong>D</strong> which is in a different history tree to <code>feature-branch</code> at commit <strong>C</strong>.</p>
<p>So how did Git handle this merge? Taking a look at the log, we see that Git has actually created a new "merge" commit, as well as bringing the commit from <code>feature-branch</code>.</p>
<pre class="no-highlight">$ git log --oneline
8ad0923 Merge branch 'feature-branch'
0c21359 Finished the new feature
40837f1 Fixed some wording
d939a3a Initial commit</pre>
<p>Upon closer inspection, we can see that this is a special kind of commit object -- it has <strong>two parent commits</strong>. This is referred to as a <strong>merge commit</strong>.</p>
<pre class="no-highlight">$ git show --format=raw 8ad0923

commit 8ad09238b0dff99e8a99c84d68161ebeebbfc714
tree e5ee97c8f9a4173f07aa4c46cb7f26b7a9ff7a17
parent 40837f14b8122ac6b37c0919743b1fd429b3bbab
parent 0c21359730915c7888c6144aa8e9063345330f1f
author Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1401134489 +0100
committer Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt; 1401134489 +0100

 Merge branch 'feature-branch'</pre>
<p>This means that our history graph now looks something like this (commit <strong>E</strong> is the new merge commit).</p>
<p><img class="aligncenter size-full wp-image-1112" src="assets/branch-merge-feature.png" alt="Branching -- after merging feature-branch" width="656" height="336" /></p>
<p>Some people believe that this sort of history graph is undesirable. In the <em>Rebasing (Continued)</em> section, we'll learn how to prevent non-fast-forward merges by rebasing feature branches before merging them with <code>master</code>.</p>
<h2>Rebasing</h2>
<p>Rebasing is without a doubt one of Git's most misunderstood features. For most people, <code>git rebase</code> is a command that should be avoided at all costs. This is probably due to the extraordinary amount of scaremongering around rebasing. <em>"Rebase Considered Harmful"</em>, and <em>"Please, stay away from rebase" </em>are just two of the many anti-rebase articles you will find in the vast archives of the Internet.</p>
<p>But rebase isn't scary, or dangerous, so long as you understand what it does. But before we get into rebasing, I'm going to take a quick digression, because it's actually much easier to explain rebasing in the context of cherry-picking.</p>
<h2>Cherry-Picking</h2>
<p>What <code>git cherry-pick</code> does is take one or more commits, and replay them on top of the current commit. Imagine a repository with the following history graph.</p>
<p><img class="aligncenter size-full wp-image-1092" src="assets/cherry-pick-before.png" alt="Node graph -- before cherry-pick" width="467" height="183" /></p>
<p>If you are on commit <strong>D</strong> and you run <code>git cherry-pick F</code>, Git will take the changes that were introduced in commit <strong>F</strong> and replay them <em>as a new commit</em> (shown as <strong>F'</strong>) on top of commit <strong>D.</strong></p>
<p><img class="aligncenter size-full wp-image-1091" src="assets/cherry-pick-after.png" alt="Node graph -- after cherry-pick" width="555" height="170" /></p>
<p>The reason you end up with a <em>copy</em> of commit <strong>F</strong> rather than commit <strong>F</strong> itself is due to the way commits are constructed. Recall that the parent commit is part of a commit's hash. So despite containing the exact same changes, author information and timestamp; <strong>F'</strong> will have a different parent to <strong>F</strong>, giving it a different hash.</p>
<p>A common workflow in Git is to develop features on small branches, and merge the features one at a time into the master branch. Let's recreate this scenario by adding some branch labels to the graphs.</p>
<p><img class="aligncenter size-full wp-image-1094" src="assets/graph-branch-labels.png" alt="Node graph -- with branch labels" width="623" height="174" /></p>
<p>As you can see, <code>master</code> has been updated since <code>foo</code> was created. To avoid potential conflicts when <code>foo</code> is merged with <code>master</code>, we want to bring <code>master</code>'s changes into <code>foo</code>. Because <code>master</code> is the <em>base</em> branch, we want to play <code>foo</code>'s commits <em>on top</em> of <code>master</code>. Essentially, we want to change commit <strong>C</strong>'s parent from <strong>B</strong> to <strong>F</strong>.</p>
<p>It's not going to be easy, but we can achieve this with <code>git cherry-pick</code>. First, we need to create a temporary branch at commit <em>F</em>.</p>
<pre class="no-highlight">$ git checkout master
$ git checkout -b foo-tmp</pre>
<p><img class="aligncenter size-full wp-image-1093" src="assets/foo-tmp.png" alt="Node graph -- after creating foo-tmp" width="623" height="174" /></p>
<p>Now that we have a base on commit <em>F</em>, we can <code>cherry-pick</code> all of <code>foo</code>'s commits on top of it.</p>
<pre class="no-highlight">$ git cherry-pick C D</pre>
<p><img class="aligncenter size-full wp-image-1089" src="assets/cherry-pick-c-d.png" alt="Node graph -- after cherry-picking C and D" width="744" height="237" /></p>
<p>Now all that's left to do is point <code>foo</code> at commit <strong>D'</strong>, and delete the temporary branch <code>foo-tmp</code>. We do this with the <code>reset</code> command, which points <code>HEAD</code> (and therefore the current branch) at a specified commit. The <code>--hard</code> flag ensures our working tree is updated as well.</p>
<pre class="no-highlight">$ git checkout foo
$ git reset --hard foo-tmp
$ git branch -D foo-tmp</pre>
<p>This gives the desired result of <code>foo</code>'s commits being upstream of <code>master</code>. Note that the original <strong>C</strong> and <strong>D</strong> commits are no longer reachable because no branch points to them.</p>
<p><img class="aligncenter size-full wp-image-1090" src="assets/cherry-pick-final.png" alt="Node graph -- after resetting foo" width="751" height="149" /></p>
<h2>Rebasing (Continued)</h2>
<p>While the example in <em>Cherry-Picking</em> worked, it's not practical. In Git, rebasing allows us to replace our verbose cherry-pick workflow...</p>
<pre class="no-highlight">$ git checkout master
$ git checkout -b foo-tmp
$ git cherry-pick C D
$ git checkout foo
$ git reset --hard foo-tmp
$ git branch -D foo-tmp</pre>
<p>...With a single command.</p>
<pre class="no-highlight">$ git rebase master foo</pre>
<p>With the format <code>git rebase &lt;base&gt; &lt;target&gt;</code>, the <code>rebase</code> command will take all of the commits from <code>&lt;target&gt;</code> and play them on top of <code>&lt;base&gt;</code> one by one. It does this without actually modifying <code>&lt;base&gt;</code>, so the end result is a linear history in which <code>&lt;base&gt;</code> can be fast-forwarded to <code>&lt;target&gt;</code>.</p>
<p>In a sense, performing a rebase is like telling Git, <strong>"Hey, I want to pretend that <code>&lt;target&gt;</code> was actually branched from <code>&lt;base&gt;</code>. Take all of the commits from <code>&lt;target&gt;</code>, and pretend that they happened <em>after</em> <code>&lt;base&gt;</code>"</strong>.</p>
<p>Let's take a look again at the example graph from <em>Merging</em> to see how rebasing can prevent us from having to do a non-fast-forward merge.</p>
<p><img class="aligncenter size-full wp-image-1111" src="assets/branch-merge-hotfix.png" alt="Branching -- after merging hotfix" width="631" height="269" /></p>
<p>All we have to do to enable a fast-forward merge of <code>feature-branch</code> into <code>master</code> is run <code>git rebase master feature-branch</code> before performing the merge.</p>
<pre class="no-highlight">$ git rebase master feature-branch
First, rewinding head to replay your work on top of it...
Applying: Finished the new feature</pre>
<p>This has brought <code>feature-branch</code> directly upstream of <code>master</code>.</p>
<p><img class="aligncenter size-full wp-image-1116" src="assets/rebase-feature.png" alt="Rebasing -- rebase feature-branch with master" width="680" height="189" /></p>
<p>Git is now able to perform a fast-forward merge.</p>
<pre class="no-highlight">$ git checkout master
$ git merge feature-branch
Updating 40837f1..2a534dd
Fast-forward
 feature.html | 1 +
 1 file changed, 1 insertion(+)</pre>
<h2>Remotes</h2>
<p>In order to collaborate on any Git project, you need to utilise at least one remote repository. Unlike centralised VCS which require a dedicated server daemon, a Git remote is simply another Git repository. In order to demonstrate this, we first need to understand the concept of a <em>bare</em> repository.</p>
<p>Recall that Git stores the entire repository inside the <code>.git</code> directory. Inside this directory are blobs and tree objects which can be traversed to build a snapshot of the entire project. This means that Git doesn't actually <em>need</em> a working tree -- it only uses the working tree to figure out what changes have been made since the last commit. This is easily demonstrated if you delete a file from a repository, and then run <code>git checkout &lt;file&gt;</code>. Despite being removed from the file system, Git can still restore the file because it has previously stored it in the repository. You can do the same thing with entire directories and Git will still be able to restore everything by traversing its tree objects.</p>
<p>It is therefore possible to have a repository which can store your project's history without actually having a working tree. This is called a <em>bare</em> repository. Bare repositories are most commonly used as a "central" repository where collaborators can share changes. The mechanism for sharing these changes will be explained in detail in the <em>Pushing</em> and <em>Pulling</em> sections. For now, let's look at creating a bare repository.</p>
<pre class="no-highlight">$ git init --bare
Initialised empty Git repository in /home/demo/bare-repo/
$ ls -l
total 12
drwxrwxr-x 1 demo demo   0 May 31 12:58 branches
-rw-rw-r-- 1 demo demo  66 May 31 12:58 config
-rw-rw-r-- 1 demo demo  73 May 31 12:58 description
-rw-rw-r-- 1 demo demo  23 May 31 12:58 HEAD
drwxrwxr-x 1 demo demo 328 May 31 12:58 hooks
drwxrwxr-x 1 demo demo  14 May 31 12:58 info
drwxrwxr-x 1 demo demo  16 May 31 12:58 objects
drwxrwxr-x 1 demo demo  18 May 31 12:58 refs</pre>
<p>Notice how rather than creating a <code>.git</code> directory for the repository, <code>git init --bare</code> simply treats the current directory as the <code>.git</code> directory.</p>
<p>There's really not much to this repository. The only interesting things it contains are a <code>HEAD</code> reference which points to the <code>master</code> branch (which doesn't exist yet), and a <code>config</code> file which has the <code>bare</code> flag set to <code>true</code>. The other files aren't of much interest to us.</p>
<pre class="no-highlight">$ find . -type f
./info/exclude
./hooks/commit-msg.sample
./hooks/pre-commit.sample
./hooks/pre-push.sample
./hooks/pre-rebase.sample
./hooks/pre-applypatch.sample
./hooks/applypatch-msg.sample
./hooks/post-update.sample
./hooks/prepare-commit-msg.sample
./hooks/update.sample
./description
./HEAD
./config

$ cat HEAD
ref: refs/heads/master
$ cat config
[core]
    repositoryformatversion = 0
    filemode = true
    bare = true
</pre>
<p>So what can we do with this repository? Well, nothing much right now. Git won't let us modify the repository because it doesn't have a working tree to modify. (Note: this isn't strictly true. We could painstakingly use Git's low-level commands to manually create and store objects in Git's data store, but that is beyond the scope of this guide. If you're <em>really</em> interested, read <a href="http://git-scm.com/book/en/Git-Internals-Git-Objects"><em>Git Internals - Git Objects</em></a>).</p>
<pre class="no-highlight">$ touch README
$ git add README
fatal: This operation must be run in a work tree</pre>
<p>The intended use of this repository is for other collaborators to <code>clone</code> and <code>pull</code> changes from, as well as <code>push</code> their own changes to.</p>
<h3>Cloning</h3>
<p>Now that we've set up a bare repository, let's look at the concept of <em>cloning</em> a repository.</p>
<p>The <code>git clone</code> command is really just a shortcut which does a few things for you. With its default configuration, it will:</p>
<ol>
<li>Create remote-tracking branches for each branch in the remote.</li>
<li>Check out the branch which is currently active (<code>HEAD</code>) on the remote.</li>
<li>Perform a <code>git fetch</code> to update all remote-tracking branches.</li>
<li>Perform a <code>git pull</code> to bring the current branch and working tree up-to-date with the remote.</li>
</ol>
<p>The <code>clone</code> command takes a URL and supports a number of transport protocols including HTTP, SSH, and Git's own protocol. It also supports plain old file paths, which is what we'll use.</p>
<pre class="no-highlight">$ cd ..
$ git clone bare-repo/ clone-of-bare-repo
Cloning into 'clone-of-bare-repo'...
warning: You appear to have cloned an empty repository.
done.</pre>
<p>Let's inspect this cloned repository to see how Git has set it up.</p>
<pre class="no-highlight">$ cd clone-of-bare-repo/
$ find . -type f
./.git/info/exclude
./.git/hooks/commit-msg.sample
./.git/hooks/pre-commit.sample
./.git/hooks/pre-push.sample
./.git/hooks/pre-rebase.sample
./.git/hooks/pre-applypatch.sample
./.git/hooks/applypatch-msg.sample
./.git/hooks/post-update.sample
./.git/hooks/prepare-commit-msg.sample
./.git/hooks/update.sample
./.git/description
./.git/HEAD
./.git/config

$ cat .git/HEAD
ref: refs/heads/master
$ ls -l .git/refs/heads/
total 0
$ cat .git/config
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    url = /home/demo/bare-repo/
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
    remote = origin
    merge = refs/heads/master</pre>
<p>This is quite literally a clone of <code>bare-repo</code>. The only difference is that this repository contains a few extra lines in <code>.git/config</code>.</p>
<p>First, it contains a <code>remote</code> listing for "origin", which is the default name given to a repository's main remote. This tells Git the URL of the repository, and which references it should retrieve when performing a <code>git fetch</code>.</p>
<p>Below that is a <code>branch</code> listing. This is the configuration for a <em>remote-tracking branch</em>. But before we get into that, let's store some data in the remote repository.</p>
<h3>Pushing</h3>
<p>We've just cloned a completely empty repository, and we want to start working on it.</p>
<pre class="no-highlight">$ echo 'Project v1.0' &gt; README
$ git add README
$ git commit -m "Add readme"
[master (root-commit) 5d591d5] Add readme
 1 file changed, 1 insertion(+)
 create mode 100644 README</pre>
<p>Notice that even though it didn't <em>technically</em> exist (there was nothing in <code>.git/refs/heads</code>), this commit has been made to the <code>master</code> branch. That's because the <code>HEAD</code> of this repository pointed to <code>master</code>, so Git has gone ahead and created the branch for us.</p>
<pre class="no-highlight">$ cat .git/refs/heads/master
5d591d5fafd538610291f45bec470d1b4e77891e</pre>
<p>Now that we've completed some work, we need to share this with our collaborators who have also cloned this repository. Git makes this really easy.</p>
<pre class="no-highlight">$ git push origin master
Counting objects: 3, done.
Writing objects: 100% (3/3), 231 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /home/demo/bare-repo/
 * [new branch] master -&gt; master</pre>
<p>Notice how we specified both the remote (<code>origin</code>) and the branch (<code>master</code>) that we want Git to push. It <em>is</em> possible to simply run <code>git push</code>, but this can be dangerous and is generally advised against. Running <code>git push</code> without any arguments can (depending on your configuration) push all remote-tracking branches. This is usually okay, but it can result in you pushing changes which you don't want collaborators to pull. In the worst case, you can destroy other collaborators' changes if you specify the <code>--force</code> flag.</p>
<p>So, let's take a look at the remote repository to see what happened.</p>
<pre class="no-highlight">$ cd ../bare-repo/
$ cat refs/heads/master
5d591d5fafd538610291f45bec470d1b4e77891e

$ git show 5d591d5
commit 5d591d5fafd538610291f45bec470d1b4e77891e
Author: Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt;
Date: Sat May 31 14:08:34 2014 +0100

 Add readme

diff --git a/README b/README
new file mode 100644
index 0000000..5cecdfb
--- /dev/null
+++ b/README
@@ -0,0 +1 @@
+Project v1.0</pre>
<p>As we expected, the remote repository now contains a <code>master</code> branch which points to the commit that we just created.</p>
<p>Essentially what happened when we ran <code>git push</code>, is Git updated the remote's references, and sent it any objects required to build those references. In this case, <code>git push</code> updated the remote's <code>master</code> to point at <code>5d591d5</code>, and sent it the <code>5d591d5</code> commit object as well as any tree and blob objects related to that commit.</p>
<h3>Remote-Tracking Branches</h3>
<p>As we saw in <em>Cloning</em>, a remote-tracking branch is essentially just a few lines in <code>.git/config</code>. Let's take a look at those lines again.</p>
<pre class="no-highlight">[branch "master"]
    remote = origin
    merge = refs/heads/master</pre>
<p>The line <code>[branch "master"]</code> denotes that the following configuration applies to the <em>local</em> <code>master</code> branch.</p>
<p>The rest of the configuration specifies that when this remote-tracking branch is fetched, Git should fetch the <code>master</code> branch from the <code>origin</code> remote.</p>
<p>Besides storing this configuration, Git also stores a local copy of the remote branch. This is simply stored as a reference in <code>.git/refs/remotes/&lt;remote&gt;/&lt;branch&gt;</code>. We'll see more about how this works in <em>Fetching</em>.</p>
<h3>Fetching</h3>
<p>The <code>git fetch</code> command is fairly simple. It takes the name of a remote (unless used with the <code>--all</code> flag, which fetches all remotes), and retrieves any new references and all objects necessary to complete them.</p>
<p>Recall what a remote's configuration looks like.</p>
<pre class="no-highlight">[remote "origin"]
    url = /home/demo/bare-repo/
    fetch = +refs/heads/*:refs/remotes/origin/*</pre>
<p>The <code>fetch</code> parameter here specifies a mapping of <code>&lt;remote-refs&gt;:&lt;local-refs&gt;</code>. The example above simply states that the references found in origin's <code>refs/heads/*</code> should be stored locally in <code>refs/remotes/origin/*</code>. We can see this in the repository that we cloned earlier.</p>
<pre class="no-highlight">$ ls -l .git/refs/remotes/origin/
total 4
-rw-rw-r-- 1 demo demo 41 May 31 14:12 master</pre>
<p>Let's see a fetch in action to get a better idea of what happens. First, we'll create a new branch on the remote repository.</p>
<pre class="no-highlight">$ cd ../bare-repo/
$ git branch feature-branch</pre>
<p>Now we'll run <code>git fetch</code> from the clone.</p>
<pre class="no-highlight">$ cd ../clone-of-bare-repo/
$ git fetch origin
From /home/demo/bare-repo
 * [new branch] feature-branch -&gt; origin/feature-branch</pre>
<p>This has done a couple of things. First, it has created a reference for the remote branch in <code>.git/refs/remotes/origin</code>.</p>
<pre class="no-highlight">$ cat .git/refs/remotes/origin/feature-branch
5d591d5fafd538610291f45bec470d1b4e77891e</pre>
<p>It has also updated a special file, <code>.git/FETCH_HEAD</code> with some important information. We'll talk about this file in more detail soon.</p>
<pre class="no-highlight">$ cat .git/FETCH_HEAD
5d591d5fafd538610291f45bec470d1b4e77891e branch 'master' of /home/demo/bare-repo
5d591d5fafd538610291f45bec470d1b4e77891e not-for-merge branch 'feature-branch' of /home/demo/bare-repo</pre>
<p>What is <em>hasn't</em> done is created a local branch. This is because Git understands that even though the remote has a <code>feature-branch</code>, you might not want it in your local repository.</p>
<p>But what if we <em>do</em> want a local branch which tracks the remote <code>feature-branch</code>? Git makes this easy. If we run <code>git checkout feature-branch</code>, rather than failing because no local <code>feature-branch</code> exists, Git will see that there is a remote <code>feature-branch</code> available and create a local branch for us.</p>
<pre class="no-highlight">$ git checkout feature-branch

Branch feature-branch set up to track remote branch feature-branch from origin.
Switched to a new branch 'feature-branch'</pre>
<p>Git has done a couple of things for us here. First, it has created a local <code>feature-branch</code> reference which points to the same commit as the remote <code>feature-branch</code>.</p>
<pre class="no-highlight">$ cat .git/refs/remotes/origin/feature-branch
5d591d5fafd538610291f45bec470d1b4e77891e
$ cat .git/refs/heads/feature-branch
5d591d5fafd538610291f45bec470d1b4e77891e</pre>
<p>It has also created a remote-tracking branch entry in <code>.git/config</code>.</p>
<pre class="no-highlight">$ cat .git/config
[core]
    repositoryformatversion = 0
    filemode = true
    bare = false
    logallrefupdates = true
[remote "origin"]
    url = /home/demo/bare-repo/
    fetch = +refs/heads/*:refs/remotes/origin/*
[branch "master"]
    remote = origin
    merge = refs/heads/master
[branch "feature-branch"]
    remote = origin
    merge = refs/heads/feature-branch</pre>
<h3>Pulling</h3>
<p>The <code>git pull</code> command is, like <code>git clone</code>, a nice shortcut which essentially just runs a few lower-level commands. In short, with the format <code>git pull &lt;remote&gt; &lt;branch&gt;</code>, the <code>git pull</code> command does the following:</p>
<ol>
<li>Runs <code>git fetch &lt;remote&gt;</code>.</li>
<li>Reads <code>.git/FETCH_HEAD</code> to figure out if <code>&lt;branch&gt;</code> has a remote-tracking branch which should be merged.</li>
<li>Runs <code>git merge</code> if required, otherwise quits with an appropriate message.</li>
</ol>
<p>At this point, it helps to understand Git's <code>FETCH_HEAD</code>. Every time you run <code>git fetch</code>, Git stores information about the fetched branches in <code>.git/FETCH_HEAD</code>. This is referred to as a <em>short-lived reference</em>, because by default Git will override the contents of <code>FETCH_HEAD</code> every time you run <code>git fetch</code>.</p>
<p>Let's introduce some new commits to our remote repository so that we can see this in practice.</p>
<pre class="no-highlight">$ git clone bare-repo/ new-clone-of-bare-repo
Cloning into 'new-clone-of-bare-repo'...
done.

$ cd new-clone-of-bare-repo/
$ git checkout feature-branch
Branch feature-branch set up to track remote branch feature-branch from origin.
Switched to a new branch 'feature-branch'

$ echo 'Some more information.' &gt;&gt; README
$ git commit -am "Add more information to readme"
[feature-branch 7cd83c2] Add more information to readme
 1 file changed, 1 insertion(+)
$ git push origin feature-branch
Counting objects: 5, done.
Writing objects: 100% (3/3), 298 bytes | 0 bytes/s, done.
Total 3 (delta 0), reused 0 (delta 0)
To /home/demo/bare-repo/
   5d591d5..7cd83c2  feature-branch -&gt; feature-branch</pre>
<p>Now, using the steps outlined earlier, let's manually perform a <code>git pull</code> on the other clone to pull in the changes we just introduced.</p>
<pre class="no-highlight">$ cd ../clone-of-bare-repo/
$ git fetch origin
remote: Counting objects: 5, done.
remote: Total 3 (delta 0), reused 0 (delta 0)
Unpacking objects: 100% (3/3), done.
From /home/demo/bare-repo
   5d591d5..7cd83c2  feature-branch -&gt; origin/feature-branch
$ cat .git/FETCH_HEAD
7cd83c29d7360dfc432d556fdbf03eb83ec5158d        branch 'feature-branch' of /home/demo/bare-repo
5d591d5fafd538610291f45bec470d1b4e77891e    not-for-merge   branch 'master' of /home/demo/bare-repo</pre>
<p>At this point, Git has updated our local copy of the remote branch, and updated the information in <code>FETCH_HEAD</code>.</p>
<pre class="no-highlight">$ cat .git/refs/heads/feature-branch
5d591d5fafd538610291f45bec470d1b4e77891e
$ cat .git/refs/remotes/origin/feature-branch
7cd83c29d7360dfc432d556fdbf03eb83ec5158d</pre>
<p>We know from <code>FETCH_HEAD</code> that the fetch introduced some changes to <code>feature-branch</code>. So all that's left to do to complete the "pull" is perform a merge.</p>
<pre class="no-highlight">$ git merge FETCH_HEAD
Updating 5d591d5..7cd83c2
Fast-forward
 README | 1 +
 1 file changed, 1 insertion(+)</pre>
<p>And that's it -- we've just performed a <code>git pull</code> without actually running <code>git pull</code>. Of course, it is much easier to let Git take care of these details. Just to be sure that the outcome is the same, we can run <code>git pull</code> as well.</p>
<pre class="no-highlight">$ git reset --hard HEAD^1
HEAD is now at 5d591d5 Add readme
$ git pull origin feature-branch
From /home/demo/bare-repo
 * branch            feature-branch -&gt; FETCH_HEAD
Updating 5d591d5..7cd83c2
Fast-forward
 README | 1 +
 1 file changed, 1 insertion(+)</pre>
<h2>Toolkit</h2>
<p>With a solid understanding of Git's inner workings, some of the more advanced Git tools start to make more sense.</p>
<h3>git-reflog</h3>
<p>Whenever you make a change in Git that affects the tip of a branch, Git records information about that change in what's called the reflog. Usually you shouldn't need to look at these logs, but sometimes they can come in <em>very</em> handy.</p>
<p>Let's say you have a repository with a few commits.</p>
<pre class="no-highlight">$ git log --oneline
d6f2a84 Add empty LICENSE file
51c4b49 Add some actual content to readme
3413f46 Add TODO note to readme
322c826 Add empty readme</pre>
<p>You decide, for some reason, to perform a destructive action on your <code>master</code> branch.</p>
<pre class="no-highlight">$ git reset --hard 3413f46
HEAD is now at 3413f46 Add TODO note to readme</pre>
<p>Since performing this action, you've realised that you lost some commits and you have no idea what their hashes were. You never pushed the changes; they were only in your local repository. <code>git log</code> is no help, since the commits are no longer reachable from <code>HEAD</code>.</p>
<pre class="no-highlight">$ git log --oneline
3413f46 Add TODO note to readme
322c826 Add empty readme</pre>
<p>This is where <code>git reflog</code> can be useful.</p>
<pre class="no-highlight">$ git reflog
3413f46 HEAD@{0}: reset: moving to 3413f46
d6f2a84 HEAD@{1}: commit: Add empty LICENSE file
51c4b49 HEAD@{2}: commit: Add some actual content to readme
3413f46 HEAD@{3}: commit: Add TODO note to readme
322c826 HEAD@{4}: commit (initial): Add empty readme</pre>
<p>The reflog shows a list of all changes to <code>HEAD</code> in reverse chronological order. The hash in the first column is the value of <code>HEAD</code> <em>after the action on the right was performed</em>. We can see, therefore, that we were at commit <code>d6f2a84</code> before the destructive change.</p>
<p>How you want to recover commits depends on the situation. In this particular example, we can simply do a <code>git reset --hard d6f2a84</code> to restore <code>HEAD</code> to its original position. However if we have introduced new commits since the destructive change, we may need to do something like <code>cherry-pick</code> all the commits that were lost.</p>
<p>Note that Git's reflog is only a record of changes <strong>for your local repository</strong>. If your local repository becomes corrupt or is deleted, the reflog won't be of any use (if the repository is deleted the reflog won't exist at all!)</p>
<p>Depending on the situation, you may find <code>git fsck</code> more suitable for recovering lost commits.</p>
<h3>git-fsck</h3>
<p>In a way, Git's object storage works like a primitive file system -- objects are like files on a hard drive, and their hashes are the objects' physical address on the disk. The Git index is exactly like the index of a file system, in that it contains references which point at an object's physical location.</p>
<p>By this analogy, <code>git fsck</code> is aptly named after <code>fsck</code> ("file system check"). This tool is able to check Git's database and verify the validity and reachability of every object that it finds.</p>
<p>When a reference (like a branch) is deleted from Git's index, the object(s) they refer to usually aren't deleted, even if they are no longer reachable by any other references. Using a simple example, we can see this in practice. Here we have a branch, <code>feature-branch</code>, which points at <code>f71bb43</code>. If we delete <code>feature-branch</code>, the commit will no longer be reachable.</p>
<pre class="no-highlight">$ git branch
  feature-branch
* master
$ git rev-parse --short feature-branch
f71bb43
$ git branch -D feature-branch
Deleted branch feature-branch (was f71bb43).</pre>
<p>At this point, commit <code>f71bb43</code> still exists in our repository, but there are no references pointing to it. By searching through the database, <code>git fsck</code> is able to find it.</p>
<pre class="no-highlight">$ git fsck --lost-found
Checking object directories: 100% (256/256), done.
dangling commit f71bb43907bffe0bce2967504341a0ece7a8cb68</pre>
<p>For simple cases, <code>git reflog</code> may be preferred. Where <code>git fsck</code> excels over <code>git reflog</code>, though, is when you need to find objects which you never referenced in your local repository (and therefore would not be in your reflog). An example of this is when you delete a remote branch through an interface like GitHub. Assuming the objects haven't been garbage-collected, you can clone the remote repository and use <code>git fsck</code> to recover the deleted branch.</p>
<h3>git-stash</h3>
<p><code>git stash</code> takes all changes to your working tree and index, and "stashes" them away, giving you a clean working tree. You can then retrieve those changes from your stash and re-apply them to the working tree at any time with <code>git stash apply</code>. A common use for the <code>stash</code> command is to save some half-finished changes in order to checkout another branch.</p>
<p>This seems fairly simple at first, but the mechanism behind the <code>stash</code> command is actually quite complex. Let's build a simple repository to see how it works.</p>
<pre class="no-highlight">$ git init
Initialised empty Git repository in /home/demo/demo-repo/.git/
$ echo 'Foo' &gt; test.txt
$ git add test.txt
$ git commit -m "Initial commit"
[master (root-commit) 2522332] Initial commit
 1 file changed, 1 insertion(+)
 create mode 100644 test.txt</pre>
<p>Now let's make some changes, and stash them.</p>
<pre class="no-highlight">$ echo 'Bar' &gt;&gt; test.txt
$ git stash
Saved working directory and index state WIP on master: 2522332 Initial commit
HEAD is now at 2522332 Initial commit</pre>
<p>Stashes in Git are put onto a stack, with the most recently-stashed on top. You can list all current stashes with <code>git stash list</code>.</p>
<pre class="no-highlight">$ git stash list
stash@{0}: WIP on master: 2522332 Initial commit</pre>
<p>Right now we only have one stash: <code>stash@{0}</code>. This is actually a reference, which we can inspect.</p>
<pre class="no-highlight">$ git show stash@{0}
commit f949b46a417a4f1595a9d12773c89cce4454a958
Merge: 2522332 1fbe1cc
Author: Joseph Wynn &lt;joseph@wildlyinaccurate.com&gt;
Date:   Sat Jul 5 00:15:51 2014 +0100

    WIP on master: 2522332 Initial commit

diff --cc test.txt
index bc56c4d,bc56c4d..3b71d5b
--- a/test.txt
+++ b/test.txt
@@@ -1,1 -1,1 +1,2 @@@
  Foo
++Bar</pre>
<p>From this we can see that the stash is pointing to a commit object. What's interesting is that the stash commit is a <strong>merge commit</strong>. We'll look into that in a bit, but first: where <em>is</em> this commit?</p>
<pre class="no-highlight">$ git log --oneline
2522332 Initial commit

$ git branch
* master

$ git fsck --lost-found
Checking object directories: 100% (256/256), done.</pre>
<p>It's not in the current branch, and there are no other branches it could be in. <code>git-fsck</code> hasn't found any dangling commits, so it must be referenced somewhere. But <em>where</em>?</p>
<p>The answer is simple: Git creates a special reference for the stash which isn't seen by commands like <code>git branch</code> and <code>git tag</code>. This reference lives in <code>.git/refs/stash</code>. We can verify this with <code>git show-ref</code>.</p>
<pre class="no-highlight">$ git show-ref
25223321ec2fbcb718b7fbf99485f1cb4d2f2042 refs/heads/master
f949b46a417a4f1595a9d12773c89cce4454a958 refs/stash</pre>
<p>So why does Git create a merge commit for a stash? The answer is relatively simple: as well as recording the state of the working tree, <code>git stash</code> also records the state of the index (also known as the "staging area"). Since it's possible for the index and the working tree to contain changes to the same file, Git needs to store the states separately.</p>
<p>This gives us a history that looks a little like this:</p>
<p><img class="aligncenter size-full wp-image-1149" src="assets/stash.png" alt="Stashing" width="504" height="266" /></p>
<p>In this history graph, the tree of commit <strong>C</strong> contains the changes to the working tree. Commit <strong>C</strong>'s first parent is the commit that <code>HEAD</code> pointed to when the stash was created (commit <strong>A</strong>). The second parent (commit <strong>B</strong>) contains the changes to the index. It is with these two commits that Git is able to re-apply your stashed changes.</p>
<h3>git-describe</h3>
<p>Git's <code>describe</code> command is summed up pretty neatly in the documentation:</p>
<blockquote><p>git-describe - Show the most recent tag that is reachable from a commit</p></blockquote>
<p>This can be helpful for things like build and release scripts, as well as figuring out which version a change was introduced in.</p>
<p><code>git describe</code> will take any reference or commit hash, and return the name of the most recent tag. If the tag points at the commit you gave it, <code>git describe</code> will return only the tag name. Otherwise, it will suffix the tag name with some information including the number of commits since the tag and an abbreviation of the commit hash.</p>
<pre class="no-highlight">$ git describe v1.2.15
v1.2.15
$ git describe 2db66f
v1.2.15-80-g2db66f5
</pre>
<p>If you want to ensure that only the tag name is returned, you can force Git to remove the suffix by passing <code>--abbrev=0</code>.</p>
<pre class="no-highlight">$ git describe --abbrev=0 2db66f
v1.2.15</pre>
<h3>git-rev-parse</h3>
<p><code>git rev-parse</code> is an ancillary plumbing command which takes a wide range of inputs and returns one or more commit hashes. The most common use case is figuring out which commit a tag or branch points to.</p>
<pre class="no-highlight">$ git rev-parse v1.2.15
2a46f5e2fbe83ccb47a1cd42b81f815f2f36ee9d
$ git rev-parse --short v1.2.15
2a46f5e</pre>
<h3>git-bisect</h3>
<p><code>git bisect</code> is an indispensable tool when you need to figure out which commit introduced a breaking change. The <code>bisect</code> command does a binary search through your commit history to help you find the breaking change as quickly as possible. To get started, simply run <code>git bisect start</code>, and tell Git that the commit you're currently on is broken with <code>git bisect bad</code>. Then, you can give Git a commit that you know is working with <code>git bisect good &lt;commit&gt;</code>.</p>
<pre class="no-highlight">$ git bisect start
$ git bisect bad
$ git bisect good v1.2.15
Bisecting: 41 revisions left to test after this (roughly 5 steps)
[b87713687ecaa7a873eeb3b83952ebf95afdd853] docs(misc/index): add header; general links</pre>
<p>Git will then checkout a commit and ask you to test whether it's broken or not. If the commit is broken, run <code>git bisect bad</code>. If the commit is fine, run <code>git bisect good</code>. After doing this a few times, Git will be able to pinpoint the commit which first introduced the breaking change.</p>
<pre class="no-highlight">$ git bisect bad
e145a8df72f309d5fb80eaa6469a6148b532c821 is the first bad commit</pre>
<p>Once the <code>bisect</code> is finished (or when you want to abort it), be sure to run <code>git bisect reset</code> to reset <code>HEAD</code> to where it was before the <code>bisect</code>.</p>
