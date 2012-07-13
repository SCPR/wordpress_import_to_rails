# Wordpress Import to Rails
This is how we at SCPR took a giant XML dump file from Wordpress and imported it into our CMS.


## Why

One of our in-house blogs, Multi-American, has been hosted on a server completely separate from
ours and managed with Wordpress. We wanted (and needed) to bring all of the content into our own
Rails/Django-based CMS and onto our own servers as quickly and efficiently as possible. Fortunately,
WordPress provides an tool to export all of its content to a well-organized XML file, which we
then took and parsed the heck out of to turn into something that Rails/ActiveRecord could understand.

This is not a general-use library. It's fairly specific to our application and is only meant to 
serve as an example, or a starting point for your import process.


## Goals

* Create a way for us to import the entire contents of a WordPress blog into our Rails application.

* **Make it fail-proof.** Confidence is key. This is a huge amount of data and if something goes 
wrong, nobody should know about it.

* **Reduce the WordPress clutter for a cleaner import.** WordPress has a very clean data structure,
but for us there is a lot of stuff that we don't need. The script should be able to distinguish 
between what is unnecessary, Wordress-specific junk, and what is meaningful content that
we can use for our website.

* **Make it smart.** We should be able to import and un-import any post in any number of ways, via
a batch-process or one-by-one.

* **Give us the ability to hand-pick certain content, or leave certain content behind.** There are upwards
of 10,000 posts here and it's likely that we'll want to drop a couple things in the process.

* **Keep the script as isolated a possible from the rest of the application.** Once the import process is 
complete, we'll want to remove this script from our repository. It also shouldn't affect anything else in
the application. Except for the views, we only had to add a few columns to the database, just so we could 
know for certain which posts were imported.

* **Don't overwrite any content that already exists.** This is especially important for tags and categories.

* **Don't store anything in the database that doesn't need to be there.** We have enough data already.


## Tools

* [Redis](http://redis.io/) - Many of the commands are specific to Redis, what we use for cache. 
Cache is a very important aspect of this library - otherwise the application would have to load 
and parse the XML file on every request! This can be replaced with any cache system of your choice, 
but you'll probably need to edit a few of the commands.

* [node](http://nodejs.org/) - The socket interaction uses a node server that I haven't included 
in this repository. It's just a basic server setup using [express](http://expressjs.com/) for routing. 
This is included just so the user has something to look at while the import process is happening. 
You can remove this and just redirect to any view.

* [Resque](https://github.com/defunkt/resque/) - The library uses Github's Resque for performing 
the import tasks asynchronously. This can be removed and replaced with just a normal (very long) 
HTTP request.

* AdminResource - this is a tool that is not yet public, but is being used here. All it really does is
tell the application how to represent the models. You can remove it and build the views manually.

* Simple Breadcrumbs - Not a gem yet, but you can see how to use and implement it 
[here](https://gist.github.com/2969085)


## Dependencies

The library is meant to be run in the context of a Rails application. 
If you're using another Ruby framework, you'll need you to require the Rails gems 
(ActiveModel, ActiveRecord, ActiveSupport, etc.), or otherwise modify the code not 
to need any of it.


## Why no tests?

This was meant to be a quick, short-lived, and isolated script. We knew we were going to drop it once we 
were done with it, and because it barely touches anything else in the application (meaning it is very 
unlikely that it will break anything else), I didn't feel it necessary to write formal tests for it.

The code is under-documented because I didn't think anybody but me would ever be looking at it and now it 
would be a poor use of my time to go back and add documentation to everything. If you have questions, 
[just ask!](bricker@scpr.org)


## Why no gem?

I feel that no matter what the case, the process of importing a Wordpress blog into a Rails application will
be a fairly specific and specialized process for each website. Hence this example, which you're welcome to copy
and paste directly into your application and then modify and extend as needed.


## Who

This script was created by [SCPR](http://scpr.org), for SCPR. If you have questions or suggestions, either 
open a Github issue or e-mail Bryan Ricker at <bricker@scpr.org>.
