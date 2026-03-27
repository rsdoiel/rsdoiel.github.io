---
author: R. S. Doiel
dateCreated: "2026-02-18"
dateModified: "2026-03-03"
datePublished: "2026-02-21"
description: |
    An exploration of what could happen if we choose a simpler end user
    friendly cooperative an ownership model for the Web and Internet.
keywords:
    - web
    - markdown
postPath: blog/2026/02/21/a_simple_web_we_own.md
title: A Simple Web We Own
---


# A simple web we own

By R. S. Doiel, 2026-02-21 (revised: 2026-03-03, epilogue added 2026-03-27)

> Tenant and product or co-owner and participant?

Today, the Web and Internet are owned and controlled by large for-profit corporations and a few governments[^1].  Corporate ownership combined with government policies has left us as tenant and product. It has given us a surveillance economy and enshittification[^2]. 

- What if I do not wish to be tenant and product?
- What can I do to change the equation? 

Those two questions lead me to a bigger question.

- What happens when ownership and control of hardware and software shifts from the domain of corporations to a world where a significant percentage are owned by individual people and cooperatives?


[^1]: Many governments sub-contract the public Internet to corporations. The corporations are the ones with real control. You see this in domain registries, data lines, storage and virtual services. The United States government today depends on Amazon. As a result Amazon holds the keys to the systems.

[^2]: Cory Doctorow both defines the term and what brought it about, see <https://us.macmillan.com/books/9780374619329/enshittification/>

I think the answer is suggested by a corollary found in the history of labor movements. When a significant percentage of industries were unionized the unions exerted a strong influence across the political economy. I think ownership of the hardware and software can mirror that impact on the Web and Internet. I think when a significant number of individuals and cooperatives own the hardware and uses simpler software we can impact the Web and Internet in a positive way. That's my hypothesis.

An observation and some common assumptions:

- Most content on the web is already created by individuals not Big Co
- Big Co persuaded people that only Big Co could provide easy Web publication
- Big Co convinced many there was no point in looking for alternatives

The assumption that only Big Co can provide easy Web publication is just flat out wrong. These systems don't last for more than a decade before they decay. Each of Big Co origin story are similar. They started small. They get to scale by having investors who fund and push rapid expansion. Innovation slows so they buy up any potential rivals. Big Co then either shut them down or fold the rival system into their product lines. The last real innovation these companies introduced was decades ago.  Lack of real innovation is one of the factors that drive the Big Co and Big Tech hype cycle. They proclaim a new shiny thing in order to maintain the circus that accumulates more money. Along the way Big Co insists on tax breaks and zero regulation as a prerequisite for innovation which isn't delivered. When they did innovate they didn't have the breaks they insist on now, hell they didn't have the investment or market lock they have now. They only need the hype cycle, not innovation, to keep the money rolling in. At the end of the day we wind up the product, we wind up being exploited and we get very little useful in return.

Folks, there is an alternative. In 1992 authoring for the Web did require significant technical knowledge. HTML itself was very challenging to teach people. It was challenging to teach computer enthusiasts! I was involved in helping out at classes that taught HTML back in the early 1990s. I speak from first hand experience. But a funny thing happened on the way to 2026. A tech writer (John Grubber and friends) came up with a simpler expression of hypertext called Markdown. You don't need to know HTML to create a web page or blog post today. You can write it or read it using Markdown. You can write it using the simple text editor that came with your operating system on the computer you own. You only need a program to flip Markdown into HTML. There are plenty of programs out there that do that.

Many efforts in the past to break free of Big Co have met with limited success. Usually the energy and effort has been spent re-creating the centralized systems as distributed systems. There was a sense we needed to offer the same experience as Big Co. While ideally individuals and groups could easily run these distributed version the reality is that it remains challenging. I'm really happy to see some of them have some degree of success[^3]. It is an impressive effort. They have broken new ground and importantly they are playing an important role in the world today. I don't think they alone will get us to where we need to go. Even Cory Doctorow uses a system administrator to setup his system. Cory Doctorow is a smart technical guy. It should be easier to do (see <https://pluralistic.net/2025/08/15/dogs-breakfast/#by-clicking-this-you-agree-on-behalf-of-your-employer-to-release-me-from-all-obligations-and-waivers-arising-from-any-a>).

[^3]: Currently Mastodon and BlueSky seem to be the most successful with a possible for longer term persistence.

I think there is a simpler path. The Web itself is a decentralized system. What is needed is an easier way for individuals to create content for it. Markdown I believe is a significant piece of the solution. You start learning it just by typing. You add the little decorations as you needed (example linking to another document or creating a bullet list). There are many software programs that can convert Markdown into an HTML page. [Pandoc](https://pandoc.org) is a brilliant example of that. There are WYSIWYG Markdown editors too (see <https://github.com/mundimark/awesome-markdown-editors>). Libre Office, v26.2, supports reading and writing Markdown documents in the same way it supports other formats. __The typing bit is not the problem.__ It's the content management piece that becomes the barrier. A website is more than a single Web page otherwise we'd be done. This is why content management systems were adopted on the Web. What you need is a way of getting to the HTML typing something easier to read and type. You need a simple way to manage the website structure for what you have written. Again there are programs that do this today. Unfortunately many are complex and come with their own steep learning curve.

The most popular content system on the web today is WordPress. It was designed to run remotely on a server. It integrates with the social web systems like Mastodon. It is open source software and you could run it on a personal computer in a pinch. Unfortunately WordPress is complex to maintain. WordPress is really a bundle of software. It requires running Apache or NginX Web Server. It requires running a database like MySQL or MariaDB. It is built from a bunch of PHP, JavaScript, CSS and templates.  WordPress out of the box does some really nice things. But it comes with overhead too.

If you are a developer WordPress isn't a huge barrier. It's dandy. But running and maintaining it amounts to running and maintaining a whole bundle of interconnected software. That takes up computer resources like memory and computation time. That is problematic. It's challenging to set it up to use as simply as you use your text editor or word processor. Your stuck because it is designed to run on a remote server. If you only want to type up some Markdown to turn into a web page WordPress adds another whole other level of complexity to that big kettle of fish.

Complex content management systems were what lead to a renaissance of popularity of using static website generators. Static websites are simple to generate, cheap and easy to host and can be surprisingly interactive. You can even hand craft a static website page by page using Markdown and Pandoc. I did that for years. What Pandoc doesn't do easily for you is provide the trimmings like RSS feeds and sitemaps. If doesn't help manage this site structure. Many people build websites with more elaborate systems like Jekyll and Hugo because, like WordPress, they provide more in the way of content management. There are literally hundreds of other static website generators out there. Unfortunately they don't completely solve the problem. The ones I've tried have been too complex or didn't run on the machines I wanted to do my writing on. I think this is because most were created by developers like me. We grew up on very large complex content management systems. So when we build our own they easily become large and complex too. That is a problem. As a writer you shouldn't need to put on a developer hat to produce a website. You shouldn't have to use Medium or Substack either. What is needed is different. What is needed is an easy way to go from Markdown documents to websites without extra knowledge. Ideally you'd only need to know Markdown to build a nice website.

This lack of simplicity disappoints me as a writer. The Web is over thirty years old. It is reasonable to expect a simpler writing system for the web. One that can run on small computers. Ones that don't make you use a text input box for writing. Yet the systems out there are are stuck with complexity because they are solving the problem faced by professional Web developers decades ago. They are making old assumptions about requiring complexity. In a way developers like me keep building formula one race cars when what is needed is a single speed bicycle. How do we get to a simple web?

I've been searching for an answer. I don't think any invention is needed. The answer in 2026 is already built-in to the Web. What is needed to change is the software holding that technology. The Web can interconnect us. The software needs to take Markdown and generate the rest of the website so we can take advantage of that. I think we need to break the assumptions of complexity of use and complexity of multi author or centralized models. The core software requirements include an easy way to express hypertext (Markdown), an easy way to generate the HTML. It needs to make content syndication and discovery automatic (create RSS files and sitemaps). The Web browser will see HTML, CSS, JavaScript, RSS, sitemap.xml but the author only needs to work with Markdown documents. I've written experimental software to prove this is possible. My hope with this post and pointing at my own software contribution will shed some light on how easy it could be. I hope it is an example that this can become collectively understood.


## What is needed?

A simple web of our own has three core characteristics.

1. A computing device owned and controlled by an individual or cooperative
2. A network owned and controlled by an individual or cooperative
3. Simple to use software that empowers us to both read and write hypertext[^4] and syndicated content

[^4]: I will talk about software I have am working on but your should not limit your choice. My hope is by showing that is possible others will step up and provide their own solutions too. Choice is necessary for a thriving ecosystem of the Web.

## Examining the current state

The Web and Internet we have today isn't required by the technologies that created it. Human choices and human organizations combined with past scarcity of knowledge and resources is what lead us to this point. That's good news moving forward. Between 1992 and 2026 resource scarcity has changed. Spreading knowledge through communication is the strength and purpose of the Web. They are solid foundations to build on if we choose.

### Changes in scarcity of resource and knowledge

Let me illustrate. In 1926 we didn't have a global e-waste problem. In 2026 it is a huge problem. In 1950 a computer filled a room and could only be afforded by governments and the largest corporations[^5]. They required special high capacity power connections. They required cooling systems. Often required physical changes to the buildings (example sub flooring for cable access and fire suppression systems). A single computer like the Raspberry Pi 400 runs $60.00 in the United States in 2026. It can run off a USB battery or wall socket. It can run in ambient temperatures. Throw in a monitor, power supply and cables and you're your computer budget comes in at about $200.00. This price includes the crazy United States tariffs. It includes the crazy AI hype inflated memory pricing[^6]. A good desktop computer capable of producing Web content and hosting it is far less than the price of a smart phone which you don't control.

[^5]: Timeline of Internet history, see <https://www.computerhistory.org/internethistory/>

[^6]: The price of RAM has risen dramatically since the start of the 2026, especially after Big Co and their AI corporate paramours inked circular deals to loan, purchase and sell to each other using assets that don't exist in reality. See <https://www.raspberrypi.com/news/more-memory-driven-price-rises/>.

### Exploring the possible, the value proposition of common nouns

Let's explore the Internet and Web not as proper nouns but as common nouns. The underlying technology is a distributed system. We happen to use it like a monolithic system. You see a similar pattern in computer operating systems. Windows is based on NT, it was based on VMS. VMS was a mini computer based multi user operating system. Linux and macOS are modeled on Unix. Unix was originally a mini computer based multi user system. Similarly our two most popular phone operating systems, Android and iOS are, on built on top of  Linux and macOS. They are multi user systems used on single user machines. We choose to use them as single systems to avoid thinking about their complexity. Similarly we assume the Web must be run by Big Co because we avoid thinking about the complexity underlying it. Abstraction and re-purposing abstraction is a common theme in software systems. Re-purposing abstraction allows us to move where the complexity is based. It allows us to experience a simple system. What's changed is we don't require Big Co to have a simple user experience. I am arguing for managing complexity through simple to use software running directly on a computer we control and own. It not a remote service. It's doesn't run until you tell it to. When it does run it takes care of the complex details of generating the website HTML, RSS and sitemaps from the simpler expression of Markdown.

The Internet is a network of network. An internet as a common noun is also a network of networks. Specifically it is a network of one or more computers connected using Internet Protocols. The Internet Protocols provides for public facing networks and private ones. One that runs on your computer and is only available to your computer is called localhost. You can author a website and view it on your own computer using localhost. Localhost is a private network. If you are running macOS, Linux, Windows or Raspberry Pi OS it's already available to you. You only need to choose to use it. You have a private network the minute you turn on your computer. You can have a private piece of the Web if you choose.

If you are lucky enough to have Internet access at home that network is probably setup as a private network. Your private network is then connected to your Internet Provider via a switch or cable modem. The Internet Provider connects our private network to the public Internet on our behalf[^7]. Both the public and private systems run using the same set of technologies and protocols. This is something we can leverage to our own ends.

[^7]: Be aware that the reason you can't share your private network with your neighbor isn't technical. Most terms of service issued by Internet Providers prohibit sharing your Internet connection with your neighbor. Remember that the next time your Internet access slows down or stops working. They are not allowing us to share.

- The Internet is just a network of networks using Internet Protocols
- The network starts on your own computer
- Networks can be private or public
- We can own a private network and connect it to another public or private one

There are two versions of Internet Protocols running in parallel today, IPv4 and IPv6 (IP stands for Internet Protocol and "v" is followed by the version number). IPv6 provides a larger possible number of uniquely identifiable connections on the network. Each network connection can provide a Web destination. Much of the globe has already shifted to IPv6. The United States lingers with quite a bit of IPv4. We stopped innovating a long long time ago. Our slow WiFi and copper wire networks reflect that.

A Raspberry Pi computer[^8] running the Raspberry Pi Operating System supports both IPv4 and IPv6. As a Raspberry Pi computer owner you don't really need to worry about the distinction. If you are connecting to more than one computer you'll need a device called a switch or router. There are cheap hardware switches used to connect computers via Ethernet (faster) or WiFi (more convenient). They usually support both protocols. This means individuals can create a local internet (a network compatible with the Internet). When I checked the prices at my local appliance store a four port network switch start at under $50.00. Some were under $20.00. By comparison when the Arpanet (the original Internet) started it required a DEC PDP-1 mini computer to interconnect networks with the Arpanet. A DEC PDP-1 cost approximately $120,000.00 (1960s United States dollars). There was a huge change in cost from then to now. Raspberry Pi and inexpensive network switches are way more available than all the DEC PDP-1 ever made. They consume far less electrical power too. You can spend less than $500.00 to create a nicely little Internet compatible network with a couple computers.

[^8]: There are many different types of small computers. I am focusing on Raspberry Pi because the 400, 500 and 500+ models present an all in one keyboard and computer combo which is easy to setup with little computing back ground. If you can attach your TV to your cable provider's box you are likely able to setup one of these computers without much more effort.
Why do I keep pointing out prices? Back in the late 1980s when I was a student and first encountered the Internet the hardware and software used to connect to it cost a small fortune. The price of an Internet connected Workstation I used at University was more than the value of my parents suburban home! Creating an Internet compatible network at my home was not possible do to coast. I actually talked to the people who setup the University's network about doing this (I commuted from a long distance). 

Fast forward to 2026. Prices have changed. Computer availability has changed. In 1969 computers were still rare devices. Today there is one built into your TV and probably your toaster. The cost and availability has radically changed since the creation of the Web too. That should inform our expectation of how things can work. Something I couldn't own or do in 1989 is ownable and very doable in 2026. In 2026 rural communities in the United States are forming their own Internet Provider cooperatives[^9]. These cooperatives are connecting homes using fiber optic cables. This transforms their access from none or slow to really fast and very reliable. It also can be done for a lower cost than relying on Big Co Internet Providers if they even service the area.

In 2026 my city of 200,000 plus people, we don't have fiber optic connections to our homes. In my case one Big Co paid the another Big Co to stop expanding home fiber access anywhere in the county of Los Angeles. That includes my city. They've been paying the other Big Co off for more than a decade. The Big Co created scarcity ensures their profit margins. They are like the rail road companies in the nineteenth and twentieth century. Not about public service, not even about being effective transport corporations. It's all about profit at the expense of the public.

[^9]: Community Networks website is a group that advocates for local network cooperatives, see <https://communitynets.org/content/cooperatives-build-community-networks>

### The Web on top of the Internet

Let's focus on the Web running on top of the Internet.  What is it?  The Web is a hypertext system built on top of the Internet. **hypertext** is the key take away. It's the Web's original killer feature. The Web's hypertext system is built from a set of core technologies. These technologies are now mature. That collection includes things like HTTP, HTML, CSS, JavaScript and RSS. The two that go back to the beginning are HTTP and HTML. Let's take a look at where these started and where we are today.

HTTP stands for Hypertext Transport Protocol. It is a way of using the Internet protocol and text to reliably transfer hypertext between computers. The interaction model is a client (requester, web browser) and server (responder, web server). It is a call and response system. In 1992 this required specialized software. It required one or more skilled specialist to run it. Most websites ran on expensive multi user mini computers that cost the price of a suburban single family home. The computers required specialists to run and maintain them too. In short it was an expensive luxury affordable only by large institutions with significant government funding[^10].

In 2026 most programming languages ship with a standard library that allows creating a web server in a few lines of code. You do not need to be a network systems programmer to create one. No networking engineer required either. Ethernet and WiFi are available as commodity hardware components that largely work plug and play. Today web servers run inside appliances. This allows them to be labeled as "smart" and to fetch a higher price. You can do the same thing these embedded devices do using a $15.00 Raspberry Pi Zero 2W, power supply and SD Card for storage. A Raspberry Pi Zero 2W can even be configured to be a public WiFi access point[^11]. That's the impact of an abundance of computers and resources. Creating Web services is a solved problem.

[^10]: Originally the Internet, including the Web was available to government funded research institutions. It was created to allow the sharing of science and technology among United States and it's allies institutions.

[^11]: See Digital Free Library plans from 2014 at AdaFruit website, <https://learn.adafruit.com/digital-free-library/what-youll-need>

The technology that originated back in 1990s is still largely the same. It has just been updated slowly over time. That slowness has lead many people to not notice the changes. They haven't fully revise their assumptions they made back in 1990, 2000, 2010 or 2020. None of what I discussed here is rocket science. It is clearly visible in computing history. Through an understanding of the historical view that you can see how things were and how they can be. I'm making the point that things have change even when the collective wisdom the Tech Bros and Big Co hasn't.

### Next neighbor opportunities

The Internet is built on next-neighbor connections. If I have a home internet owned by me and my neighbor has their own little home internet we can connect them. I literally can pass an Ethernet cable through the fence if necessary. Doing so forms a slightly larger network. If we choose we could split the costs of connecting to the public Internet assuming we had a provider willing to connect us in their terms of service. Internet cooperatives take advantage of this simple relationship. The recurring bills are electricity and the common connection to a larger publicly connected Internet. The way the Internet evolved is that each organization (university or research institution) payed to connect to their neighbor and agreed to carry their neighbor's traffic as well as their own. Larger organizations wound up having multiple connections to other institutions. They operated like hubs. Multiple connections enhanced reliability. Smaller institutions might connect only to one other Internet site. That was called a leaf connection on the network. Importantly whether you were a hub or leaf you could reach any other available site in the network just by knowing it's address.

The old metaphor, Internet Super Highway, was based on the corollary that each town paid for its road and they paid for a road connecting to next ones. Roads interconnect. Traffic, in the form of cars, trucks and motorcycles, can follow the roads from one town to another. The road system can be expanded to include new towns, home, cities or other destinations. Like the road system the Internet is extensible. It can be expanded as needed just by adding connections.

A home might be a computer, a town might be a local network with a small collection of computers and cities might be large hubs with large data centers owned by Big Co. In the real world most roads are owned collectively by the public. Some roads are private. Some are private roads allow access for a toll. All are still just roads. The Internet today is built as a series of toll roads. There are few public roads. We all pay for access in cash, in loss of privacy and loss of autonomy. Many commercial Internet Providers prohibit direct sharing of the your network with your neighbors in their terms of service. These are human organizational choices. They are not technical choices or constraints.

On the Internet today most people might own the device (example phone) but they are still renting access where the payments are in the form of currency, of lost privacy and lost autonomy. When the companies wish they can force the purchase of a new devise by using the Internet to deliver software which disables them. This is the big reason I think we need to change our relationship. The country prospered when the public freeway system was created in the 1950s. The country could prosper if we had a real option of public Internet access mirroring our public roads. In the mean time we can take maters into our own hands. Own and control our computers and local networks. Form cooperatives for connecting to the Internet where appropriate.

## Changing the ownership model

It feels like a paradox. Ownership and control of our hardware give us agency to function better collectively. It reminds me of the adage, "you reach the global by first focusing on the local".  What an interesting human concept. If we own our hardware and control it we can choose to band together in cooperatives. We can change the equation and get out from under the thumb of Big Co and their toll system.

Many of us carry a smartphone in our pockets. These are computers but most are not suited to creating a Web of our own. Why? If you are using an iPhone running iOS or an Android phone provisioned with Google's software then Apple, Google or another Big Co controls your device. This is true even though you may have thought you purchased the phone. Case in point I used to carry a Samsung phone. I really enjoyed it. It ran a version of Android controlled by Samsung. Samsung sent an update that bricked (disabled) the phone. When I reached out to them the automated email reply indicated since my device was over 3 years old I would have to buy a new one. My phone was five years old. It worked really well and I liked it. Samsung had made the decision that they would update the software on my phone knowing that it would make it inoperable. Needless to say I haven't owned a Samsung phone since. I haven't trusted any Android device since. My Apple iPod mini faced a similar situation. My point is I owned the hardware but didn't control the software. It was really convenient that updates were pushed out. I really liked not paying attention to the detail. My life is busy. That arrangement worked well right up until it didn't. If a corporation or government controls the software then they also control the hardware. It doesn't matter how much you payed to purchase it. You don't really own it. Good to know.

So this is what I propose. We individually obtain computers where we control the software on it. The computers don't have to be powerful. I've done real computing (writing software) using Raspberry Pi 400 and Raspberry Pi 500. I have chosen to go with new computers because I own them a really long time. I still have a Raspberry Pi 2 that works. Skipping Starbucks and some Pizzas allowed me to save for these relatively inexpensive new computers. I understand that I'm privileged that I can afford these.

You don't have to go with new machines. There are less expensive options. I have a ten and another fifteen year old Mac Mini. I still can use them. I got them used. I think I paid five dollars for one and the other was given to me. Since they know IPv4 I can run them on my private network. I wouldn't run them on the public Internet. Apple stopped updating their OS for these machines decades ago. They can be run safely on a private network. They don't run the latest web browser but my website doesn't use the latest bells and whistles either. My point is they still work and can be used to curate or produce web content even if another machine is used to make it available on the public Internet.

There is a thriving market in refurbished and used machines. Companies and governments often lease hardware. When the lease is up after two or three years all that equipment goes either to e-waste or is resold. Going refurbish and used has the advantage of not adding to the e-waste problem. There are also civic groups that get refurbished equipment to people that need it at low or no cost. Getting a computer to write web content can be challenging but it is possible even when you have limited means. You don't need a powerful machine, you don't need the latest fastest one either. You need one that has a text editor and can run software to turn Markdown into HTML.

Here's what I used for writing this post (it has the advantage of being portable to the nearest electrical plug).

- Raspberry Pi 500 and power supply
- Raspberry Pi Monitor and power supply
- Raspberry Pi Mouse
- cables to connect everything
- a wireless switch connected to a cable modem and my Internet Provider
- A Raspberry Pi 3B+ with a 3 gigabyte hard drive setup as a "server" (makes this site available on my home network[^12])
- I publish this site via GitHub Pages service for public Internet access (I have the least expensive subscription for this)

[^12]: I can view my personal web on my home network from my phone, tablet and computers. So can the rest of my family.

The software I am using to write this post is as follows (all programs are open source software, free to share, free to use)

- Raspberry Pi OS (a Linux distribution based on Debian GNU Linux)
- Firefox (web browser)
- Mousepad (the text editor that ships with Raspberry Pi OS)
- antennaApp (a command line content system and web server I wrote)

With this software and hardware setup I can published my blog (see <https://rsdoiel.github.io>) and I can aggregate the news (see <https://rsdoiel.github.io/antenna>). I run the most up to date copy of both on my private home network. I can view the home network copy on my phone as well as my computer. My family can view it too on the home network. I update the public copy periodically. That way when I am away from my home network I can still read the aggregated news.

The setup provides a little corner of the Web which I own and control. It is not hard to replicate it for yourself. I don't need to use Yahoo News, Google News, Bing, Twitter/X, Facebook, Instagram, Whats App, Spotify, YouTube to know what is happening. I just check my own aggregations. Since I didn't implement an infinite scroll and I aggregate on a slow schedule I don't get stucked doom scrolling. Slow news gives me more time for being with the humans I love and experiencing real life without distraction. When I read my aggregated site it feels much more like choosing to read a newspaper or magazine. The open source software I created to make this easy to do is called [Antenna App](https://rsdoiel.github.io/antennaApp). You can run the latest version on macOS, Windows, Linux and Raspberry Pi OS machines.

The Antenna App software is driven my Markdown files. Markdown is a really good expression of hypertext. Posts and pages are Markdown files. The list of websites I aggregate are defined by Markdown files containing a list of links to the RSS news feeds. The Antenna App takes care of harvesting content and generating the HTML files, RSS and sitemaps used by your web browser. Antenna App is written as a command line tool. It could be re-implemented as a graphical system or interactive program. My software is released under an open source license so anyone can build on what I've already provided as long as they respect the terms of the license (a GNU license). There are other software systems out there. I mention mine because it proves it is possible. You should look for one that works for you.

## Tiny computers are like tiny homes

I use two computers for my home network. One is a Raspberry Pi 500 and the other is a Raspberry Pi 3B+ with a USB hard drive.  I write using the Pi 500 but the Pi 3B+ is where this blog lives. A public copy is managed via Git and GitHub. The public copy is where you are likely reading this. But the public copy is just that, a copy. It's cheap to copy bits in digital space.

I could actually just use the one. That's because operating systems like Raspberry Pi OS support the concept of localhost. Localhost presents the machine as if it is a network node.  If I had a Linux based phone I could run the aggregation service directly on it. Then I would have my Web right there in my pocket. In the meantime, I am saving my pennies for a Linux-based phone.

Working with small computers is like living in a small or tiny home. It can be very cozy and comfortable. It will never be a mansion. Mansions and castles are fine for some people. While I've enjoyed visiting a few castles I would not choose to live in one. There are really expensive to own, heat/cool and maintain. I like small and simple. I choose to live in a cottage.

I accept living in a small home isn't for everyone just as running little computers isn't for everyone. That is why I don't say people should abandon the computer systems that work for them. I am pushing for people, like myself, who have a problem with the predatory Web and Internet we have today. Assert ownership (individually or collectively) to correct our relationship. Collectively we need a Web and Internet where we are co-owner and participant. I am no longer interested in being a tenant and product.

## Epilogue, RSD 2026-03-27

It's been several weeks since I wrote this post. I was surprised at some of the places it popped up. Especially the ones I haven't visited for decades. There was a flavor of reaction that I expected and also found curious. It boiled down to, "I am not owned or a product, you're owned and your are a product". The subtext is I struck a nerve. To salve that point I would like to point out that this has been a problem a long time coming. Better thinkers and writers than me have more forcefully stated this.

> "[It is now a Friday morning in 2025, and that godly future for customers is still not here. Yes, we have more market power than in 2012, but we are digital serfs whose powers are limited to those granted by  Amazon, Apple, Facebook, Google, Microsoft, and other feudal overlords. This system is a free market only to the degree that you can choose your captor. ](https://projectvrm.org/2025/05/16/how-do-we-get-to-the-intention-economy/#:~:text=It%20is,captor%2E)", Doc Searls, <https://projectvrm.org/2025/05/16/how-do-we-get-to-the-intention-economy/>, visited 2026-03-27.

The second category of reaction was a criticism of where I host **the public copy of this blog**.  Perhaps this was a failure in clarity. The original post is long. Let me clarify. I see three spaces of Internet and Web possibilities. The first is one a machine control by the individual. It is referred to as localhost. The second space is on a local network. This may be controlled by us or an organization we choose to affiliate with. Often we affiliate with many local networks depending on where we are geographically and temporally. The third is the public Internet currently held captive by corporations and monied interests, aka Big Co. My content on the public Internet and Web is **a copy of my personal web available on my personal network**. It exists first in my local space. As Kevin Kelly stated, "[The internet is a copy machine](https://kk.org/thetechnium/better-than-fre/#:~:text=The%20internet,free)"[^13]. Bits are cheap to copy in digital space. That cheapness is a significant tool in changing our relationship with the current system. Doc Searls expressed eloquently in the Clue Train Manifesto, [Markets are conversation](https://cluetrain.com/book/markets.html). This difference I'm talking about in this post is in essence re-discovering a mature set of technologies that allow us to achieve a degree of influence on the public Internet and Web we lack today. I can take the conversation with me geographically, temporally and across networks.

[^13]: kk.org, post on 2008-01-31, "Better than free", <https://kk.org/thetechnium/better-than-fre/>, visited 2026-03-27. 

A third category of reaction had to do with current state of regulation. It followed points like, "you aren't permitted to run your own fiber under public roads". Valid point but that is why I mentioned "cooperatives" so often. [Community internet](https://ilsr.org/broadband/) initiatives exist. They are not necessarily trivial to start but when you start sharing the burden across a community we can take advantage of the fact that each of us brings a different skill set to the table. Additionally local governments often can be made responsive to local needs. This is particularly true in my region when improving connectivity can help local businesses regardless of their business sector.  Acknowledging that the wants of Big Co doesn't really cover the needs of the rest of us is only a small shift in point of view.

Let me be explicit. I think to counter the current corrosive corporate public Internet we have today we need a significant percentage of people to own and control their digital presence by direct ownership and control of the communication hardware and software. Sorry for the long sentence. What is a "significant percentage"?  I'm not sure other than it needs to be measurable and large enough to get corporations to respond. It could be a few percentage points, it could be double digit percentages. I suspect the percentage will be similar to labor unionization's impact in the labor markets. Based on [Figure 1](https://home.treasury.gov/news/featured-stories/labor-unions-and-the-us-economy#:~:text=Figure%201%3A%20Union%20Membership%20and%20Inequality) from <https://home.treasury.gov/news/featured-stories/labor-unions-and-the-us-economy> (viewed 2026-03-27) I'd guess the percentage needs to be around 15%. That assumes of course that surveillance economy treats attention as markets treat labor. I concede that is an assumption on my part.

Changing the current state means taking ownership. It means starting on a machine you control. You **can** still participate in the public Internet/Web. **Make that presence be a copy**. That way if the rent gets too high you can "move" digitally speaking. Not convenient necessarily but certainly possible in early 2026. The Internet blurs geographic distance, we can take advantage of that too.

References:

- [Doc Searls: Markets are Relationships](https://www.youtube.com/watch?v=ZaFmSmDdZBA)
- [Doc Searls: Four Roads to the Intention Economy](https://projectvrm.org/2025/05/16/how-do-we-get-to-the-intention-economy/)
