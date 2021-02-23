---
title: "Words Matter"
author: "R. S. Doiel"
date: "2020-07-08"
keywords: [ "civil rights", "diversity", "equality" ]
copyright: "copyright (c) 2020, R. S. Doiel"
license: "https://creativecommons.org/licenses/by-sa/4.0/" 
---

# Words Matter

By R. S. Doiel, 2020-07-08

UPDATE (2020-08-15, RSD): When I added a post today I was VERY pleased to 
to see that GitHub now allows me to publish my blog via the "main" branch.
It's nice to see the change in the words we use.

**Why does software development use the vocabulary of slavery and
Jim Crow to describe our creations?** What we call things matters.
This is especially true of the words we use day to day without thinking.

```shell
    git pull origin master
```

"Naming things is a hard problem in computer science." That is
a phrase I remember from my student days. We name variables,
programs and algorithms. We name architectures. Naming is a choice.
The names convey meaning and intent. Names and terms are a human
communication. They matter.

```shell
    git push origin master
```


## Names can change

I remember the first time I encountered the terminology "master/slave"
describing network and database architecture. I remember cringing at
the terms. I accepted the terminology because I was a student and
naively assumed that those terms were chosen innocently and did not
mean what they did. I was wrong.

Example MySQL command:

```sql
    CHANGE MASTER TO MASTER_HOST=host1,
    MASTER_PORT=3002 FOR CHANNEL 'channel2';
```

When I did not challenge the use of those terms in computer science
I became complicit in the status quo of systemic racism. I am not happy
about that. Not then and not now.  We need inclusive language
in engineering. We need real diversity to find solutions to
today's challenges.  In software engineering we very much control what
we call things. Software is an explicit form of written human
communication. Words count. Words directly impact culture and our
community.

Example MySQL commands:

```sql
    START SLAVE;
    RESET SLAVE;
    STOP SLAVE;
```

As a direct benefactor of white male privilege I find the
terminology of "master/slave" offensive.  I am certain those
words caused injury to those who did not benefit from the same white
male privilege.  Using "master/slave" terminology to describe database,
replication, network architectures or as used with version control
systems like Git is like polishing statues that glorify slavery.
It endorses inhumanity in a subtle and casual way.

We have a choice about how we communicate and what we communicate
to convey meaning.  Let's use better words. It is time to change
some.


## Practice Change

**To change our community's vocabulary we need to thoughtfully choose terms**.
My friends and colleagues introduced me to using the term "main" as
a better descriptive word than "master" in Git repositories. When
I started making the branch name changes in my Git repositories I ran
across a problem at GitHub.


## Note the problem

Recently GitHub made it possible to easily change the default branch.
For a number of years you could change the published documentation
branch from "gh-pages" to something you prefer.
What you can't do is change the name of the branch used to publish
personal and group websites.  **GitHub explicitly states that the
publication branch must be named "master".** I tested this and
confirmed the documentation is accurate as of today (2020-07-08, morning).

With the recent improvements in GitHub to allow default branches to
be named better it seems odd that you still have to publish
personal and group pages to "master" in order to publish a website. It
never made sense to me that person and group pages didn't use the default
of "gh-pages" in the first place.


## Taking action

Morning (2020-07-08): I submitted a ticket to GitHub asking to have
the option of using another word besides "master" for the publication
branch in publishing my personal GitHub pages (i.e. this blog).
Unfortunately the ticket doesn't have a public URL. I don't know how many
other people have submitted similar requests. If only a few people
have requested this recently it will not be changed. Such is the nature
of systemic problems.

Please help improve the words and names we use in software.
I believe it can make a difference in creating a more inclusive and
equitable community and profession. Raise the issue when it comes to
your attention. Silence becomes acceptance with systemic problems.

## A reply

Evening (2020-07-08): I got a reply today from Steve G of customer
support. Not sure if the reply is a bot or human.  It was a nice polite
reply (I wrote a nice polite ticket).  Steve mentioned that CEO Nat
Friedman had addressed this on twitter and to follow the GitHub blog
news.  Steve said dropping master was a priority for GitHub but there
is no time line for implementation.

I am not sure how you can develop software with a priority in mind and
not have a sense of time it takes to implement it.  I mentioned that in my
response to Steve G.

After some Duck Duck searching I found a [BBC article](https://www.bbc.com/news/technology-53050955) dated June 15th, 2020 where Nat made the
announcement about Microsoft's GitHub making the change away from "master".
Next week is July 15th. It will be interesting to see how much of an unscheduled priority this change is.

I am skeptical.  If Steve G had indicated that they are actively working
the problem and provided a general time range I would be more inclined to
give Nat, GitHub and Microsoft the benefit of the doubt.  Given the rest
of the content I read on Nat's twitter feed I don't think this is a priority
beyond press, publicity and stock price.


## Where to go from here?

Just as many sites have adopted more gender neutral terms in documentation
practice we should encourage better descriptive terms for our algorithms,
and architectures. If you run into terms perpetuating exclusion please
speak up.  Most of the web runs on web servers and databases.  Like GitHub
those software projects frequently use the terminology of "master/slave".
It is especially prevalent in documentation about replication. Blindly
perpetuating the "master/slave" terminology to describe distributed
software and architectures is like polishing a statue to the old
Confederacy. It can and should be change. We can communicate better
without perpetuating the vocabulary of Jim Crow, segregation, slavery
and oppression.

