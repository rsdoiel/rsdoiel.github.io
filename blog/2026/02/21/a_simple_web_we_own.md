---
author: R. S. Doiel
dateCreated: "2026-02-18"
dateModified: "2026-02-21"
datePublished: "2026-02-21"
postPath: blog/2026/02/21/a_simple_web_we_own.md
title: A Simple Web We Own

---


# A simple web we own

By R. S. Doiel, 2026-02-21

> Tenant and product or co-owner and participant?

Today the Web and Internet is owned and controlled by large for profit corporations and a few governments [^1]. Corporate ownership combined with government policies has left us as tenant and product. It has given us a surveillance economy and enshittification[^2]. What if I do not wish to be tenant and product? What can I do to change the equation? These two questions lead me to one more

- What happens when ownership and control of hardware and software shifts from the domain of corporations to a world where a significant percentage are owned by individual people or cooperatives?


[^1]: I say a few as many sub-contract to corporations giving the corporations the real control.

[^2]: Cory Doctorow both defines the term and what brought it about, see <https://us.macmillan.com/books/9780374619329/enshittification/>

From looking at the history of labor movements I think their is a corollary. When a significant percentage of industries were unionized they formed a strong influence on the political economies as a whole. I think ownership of the hardware and software for a significant number of individuals and cooperatives can have the same impact on the Web and Internet today. That's my hypothesis at least.

A couple of observations

1. The content of the web is already created by individuals, particularly after the arrival of "social media" created by Big Co
2. Big Co persuaded people, including so many developers, that the easy web publication was only possible through them and there was little reason to compete due to the network effects

This has happened and in spite of the lock in justified by the "network effect" in a world where these systems don't last for than a decade before they decay. That is the reason by Big Co keeps buying up potential revivals and pours so much money to neuter anti-trust enforcement. It is why innovation has stopped while the hype is driven more by the stock market and predatory investment firms than social good or usefulness.

Folks there is an alternative. In 1992 authoring for the Web did mean significant bar of technical knowledge. HTML itself was very challenging to people who were not computer enthusiast. But a funny thing happened on the way to 2026. Technical oriented writers came up with a simpler expression of hypertext called Markdown. You don't need to know HTML to create a web page or blog post today.

There has been allot of effort spent re-creating the centralized system experience offered by Big Co as distributed systems that groups or individuals could run. I'm really happy to see some of them have some degree of success[^3]. It has been an impressive effort. What I have been disappointed in is the fact that we have all we need for an interconnected human with Web, a socially connected Web without any level centralization beyond communication. The core software requirements are an easy way to express hypertext and an easy means of syndicating your content. At a machine level this is expressed as HTML and RSS. Markdown can be used to express both. It just needs to be trivially easy to do so. My hope is that collectively this can be broadly understood.

[^3]: Currently Mastodon and BlueSky seem to be the most successful with a possible for longer term persistence.

## What is needed?

A simple web of our own has three core characteristics.

1. A computing device owned and control by the individual or cooperatives
2. A network we own and control by the individual or cooperative
3. Simple to use software that empowers us to both read and write hypertext[^1] and syndicated content

[^4]: I will talk about software I have am working on but your should not limit your choice. My hope is by showing that is possible others will step up and provide their own solutions too. Choice is necessary for a thriving ecosystem of the Web. We lack significant choice today.

## Examining the current state

The Web and Internet we have today isn't required by the technologies that created it. Human choices and human organizations and scarcity of knowledge and resources is what lead us to this point. That's good news moving forward. Already resource scarcity has changed. Spreading knowledge through communication is the strength and purpose of the web. The are solid foundations to build on if we choose.

### Changes in scarcity of resource and knowledge

Here is a case in point. In 1926 we didn't have a global e-waste problem. In 2026 it is a huge problem. In 1950 computers filled rooms and could only be afforded by governments and the largest corporations[^5]. In 2026 a single computer like the Raspberry Pi 400 runs $60.00 U.S. dollars. Throw in a monitor, power supply and cables and you're at about $200.00 U.S. A fancy setup like a Raspberry Pi 500+ is about $200.00 U.S. dollars. I'd like to point out that those prices are in spite of crazy U.S. tariffs and AI hype inflated memory pricing[^6].

[^5]: Timeline of Internet history, see <https://www.computerhistory.org/internethistory/>

[^6]: The price of RAM has risen dramatically since the start of the 2026, especially after Big Co and their AI corporate paramours inked circular deals to loan, purchase and sell to each other using assets that don't exist in reality.

### Exploring the possible

Let's explore the Internet and Web not as proper nouns but as common nouns. The underlying technology after all is based on distributed systems even though we have used them as a single system. You see this pattern in the operating systems of our computing devices. Windows is based on NT, it was based on VMS which is a multi user operating system. macOS and Linux are built modeled on Unix systems. Even the two popular phone operating systems, Android and iOS are built on multi user systems. We just choose to use them as single systems. Abstraction and re-purposing is a common theme in software systems.

The Internet is a network of network. An internet (what used to be called an intranet) is a network (one or more computers) connected using Internet Protocols (abbr IP). The Internet provides both for public facing networks and private ones. The one that runs on your computer and is only available to your computer  is called localhost. It is a private network. If you lucky enough to have Internet access at home that network is probably also a private network. The private network is then connected to your Internet Provider who bridges access to the public Internet. Both the public and private systems run using the same set of technologies and protocols. This is something we can leverage to our own ends.

Their are two versions of Internet Protocols running in parallel today, IPv4 and IPv6. The later provides a larger possible number of uniquely identifiable nodes on the network to be connected. Much of the global has already shifted to IPv6. The United States lingers with quite a bit of IPv4. We stopped innovating a long long time ago. 

A Raspberry Pi computer running the Raspberry Pi Operating System supports both. Most cheap hardware switches used to connect computers via Ethernet or WiFi also support both protocols. This means individuals can create a local internet (network compatible with the Internet). Small four port  switches start at under $50.00 U.S. I've seen used ones advertised for under  $20.00 U.S. dollars. By comparison when the Arpanet was created interconnecting networks to form Arpanet required a dedicated DEC PDP-1 mini computer (approximately $120,000.00 investment). That is a huge change in cost as well as availability.

What do I keep dropping prices? Back when I was a student and first encountered the Internet (pre-Web), the hardware and software to have a node on the Internet costs a small fortune. I remember price of a Workstation was more than the appraised value of my parents suburban home!  Prices have changed. Availability has changed. In 1969 computers were  still rare devices. Today there is one built into your TV and probably your toaster. The cost and availability changes since the introduction of the Web radically changes who can own things. In 2026 rural communities in the United States are banning together and forming their own Internet Provider cooperatives. They are connecting homes using fiber optic cables[^6]. Something that isn't available in my city. In my case one Big Co paid the other Big Co to stop expanding home fiber access. Neither really wanted to have everyone connected over a reliable fast network since ultimately it makes network access less scarce and therefore less profitable to them.

[^6]: Community Networks website is a group that advocates for local network cooperatives, see <https://communitynets.org/content/cooperatives-build-community-networks>

Now let's look at the Web. What is it?  The Web is a hypertext system built on top of the Internet. **hypertext** is the key take away. It's the Web's original and still killer feature.  The Web's hypertext system is built from a set of core technologies that are now mature.  That collection includes things like HTTP, HTML, CSS, JavaScript and RSS. The two that go back to the beginning are HTTP and HTML Let's take a look at where these started and where we are today.

HTTP stands for Hypertext Transport Protocol. It is a way of using the Internet protocol and text to reliability transfer text from one computer to another typically in a client (requester) and server (responder) relationship. It is a call and response system. In 1992 this required specialized software and a specialist skill to run it. Most website (and there were not many at first) ran on expensive multi user mini computers that hosts the price of suburban single family homes. They required specialists to run and maintain them too. In short it was an expensive luxury affordable only for large institutions with significant government funding[^7]. In 2026 most programming languages ship with a standard library that provides for a web server in a few lines of code. You do not need to be a systems programmer to create one. No more networking software engineer required either as Ethernet and WiFi are commodity hardware components today. Today web servers run inside appliances allowing them to be labeled as "smart". You can do this same thing using a $15.00 Raspberry Pi Zero 2W, power supply and SD Card for storage. That device can even be configured to be a public WiFi access point[^8]. That's the impact of an abundance of computers and resources.

[^7]: Originally the Internet, including the Web was available to government funded research institutions. It was created to allow the sharing of science and technology among United States and it's allies institutions.

[^8]: See Digital Free Library plans from 2014 at AdaFruit website, <https://learn.adafruit.com/digital-free-library/what-youll-need>

Just to be pedantic the technology that originated back in 1990s is still largely the same. It has just been updated slowly over time. That slowness has lead many people to not notice the changes and revise their assumptions they made back in 1990, 2000, 2010 or 2020. None of what I discussed here is rocket science. It is clearly visible in computing history and by observation. I'm making the point that things have change even when the collective wisdom the Tech Bros and Big Co hasn't.

### Next neighbor opportunities

The Internet is a next neighbor connection proposition. If I have a home internet owned by me and my neighbor has their own little home internet we can connect them. It forms a slightly larger network. If we choose we could split the costs of connecting to the public Internet. This is the what Internet cooperatives take advantage of. The recurring bills are electricity and the common connection (example a T1 line or fiber connection) to a larger publicly connected Internet. The way the Internet evolved is that each organization (university or research institution) payed to connect to their neighbor and agreed to carry their neighbor's traffic as well as their own. Larger organizations could have multiple connections to other institutions. This enhanced reliability where smaller institutions might be a leaf on the network.

The old metaphor the Internet Super Highway was based on the corollary that each town paid for its road and they paid for a road connecting to another one. These roads interconnect. Traffic, in the form of cars,trucks and motorcycles, can follow the roads from one town to another. The road system can be expanded to include new towns, homes and cities. The Internet itself is like that where the a home might be a device,  a town might a local network with a small collection of computers (an organizations data center and workstations) and cities (large data centers owned by Big Co). Today many people live in cities and rent their owns, on the Internet today most people might own the device but you're still renting through payment and your personal information apartments in the Big Co city.

It feels like a paradox that ownership of our hardware gives us agency to function better collectively. It reminds me of thee old adage, you reach the global first by being local.  What an interesting human concept.

## Changing the ownership model

Many of use carry a smartphone in our pockets. There are computers but most are not suited to creating a web of our own. Why? If you are using an iPhone running iOS or an Android phone provisioned with Google's software then they control your device even through you may have thought you purchased it. Case in point I used to carry a Samsung phone. I really enjoyed it. It ran a version of Android controlled by Samsung. Samsung sent an update that bricked the phone. When I reached out to them the automated email reply indicated since my device was over 3 years old I would have to buy a new one. My phone was five years old, it worked really well and I liked it. Needless to say I haven't owned a Samsung phone since. I've also haven't trusted any Android device since. My Apple iPod mini faced a similar situation. My point is I owned the hardware but didn't control the software. It was really convenient that updates were pushed out. I really liked not paying attention to the details, life is busy. That arrange worked right up until it didn't. If a corporation or government controls the software then they also control the hardware. Good to know.

So this is what I propose. We individually obtain computers where we control the software on it. They don't have to be powerful. I've done real computing (writing software) using Raspberry Pi 400, Raspberry Pi 500 and when I decided to really splash out a Raspberry Pi 500 plus. I chose to go with new computers because I own them a really long time.  I still have a Raspberry Pi 2 that works. You don't have to go with new machines. I have ten and fifteen year old Mac Minis I still can use. Since they know IPv4 I can run them on my private network. I wouldn't run them on the open Internet, Apple stopped updating their OS for these machines decades ago. My point is they still work and can be used to curate or produce web content even if another machine is used to make it available on the public Internet. There is also a thriving market in refurbished or used machines. Companies and governments often lease hardware. Then the lease is up after two or three years all that equipment goes wither to e-waste or is resold. Going refurbish and used has the advantage of not adding to the e-waste problem.

Here's the hardware kit I used for writing this post (it has the advantage of being portable to the nearest electrical plug).

- Raspberry Pi 500 and power supply
- Raspberry Pi Monitor and power supply
- Raspberry Pi Mouse
- cables to connect everything
- a wireless switch connected to a cable model and my ISP allows me to publish this via GitHub
- A Raspberry Pi 3B+ with a hard drive as "server" and makes this site available on my home network[^9]

[^9]: I can view my personal web on my home network from my phone, tablet and computers. So can the rest of my family.

The software I am using to write this post is as follows (all are open source)

- Raspberry Pi OS (a Linux distribution based on Debian GNU Linux)
- Firefox (web browser)
- Mousepad (the text editor that ships with )
- antennaApp (a command line content system and web server I wrote)

With this software and hardware setup I can aggregate the news (see example at https://rsdoiel.github.io/antenna) and I can published by blog (see https://rsdoiel.github.io). I run a updating copy of both the my aggregation and blog site on my home network reachable by the local private network WiFi. I can view it on my phone as well as my computer. My family can view. I update the public copy periodically too. That way when I am away from my home network I can still read the aggregated news. When I visit my sons at their home I can show them the article I found exciting. I can even text them the URL from my public aggregation site.

The setup, which you can replicate yourself, provides a little corner of the Web which I own and control. I don't need to use Yahoo News, Google News, Bing, Twitter, Facebook, Instagram to know what is happening. I just check my own aggregations. Since I don't implement an infinite scroll and I aggregate on a schedule I don't get sucked into doom scrolling. This gives me more time for being with the humans I love and experiencing real life without distraction. When I read my aggregated site it feels much more like my local newspaper or magazine did back before the era of Big Co websites. I call my software [Antenna App](https://rsdoiel.github.io/antennaApp).

The Antenna App software is driven my Markdown files. Posts and pages are first Markdown files. The list of websites I aggregate are Markdown files. The Antenna App takes care of converting those into HTML pages, RSS files and sitemaps expected on modern website. While I've implemented my software as a command line tool (which will turn off many people) it could be re-implemented as a GUI or TUI based system. My software is released under an open source license so anyone can build on what I've already provided as long as they respect the terms of the license (a GNU license).

## Tiny computers are like tiny homes

While I use two computers (Raspberry Pi 500 and Raspberry Pi 3B+) for my home setup. I could actually just use the one. That's because Linux based systems support the concept of localhost. Localhost presents the machine as if it is on the network.  If I had a Linux based phone (still saving my pennies) I could run the aggregation service right on it directly. Then I would have my Web in right in my pocket. Working with small computers is like living in a small or tiny home. It can be very cozy and comfortable bit it will not be a mansion. Mansions and castles are fine. I choose to live in a cottage. It is really expensive to own and run a castle. While I've enjoyed visiting a few I would not choose to live in one. I like small and simple. Just as I accept living in a small home isn't for everyone running little computers isn't for everyone. That is why I don't say people to abandon the computer systems that work for them. What I am pushing for is  those people, like myself, that have problems with the predatory systems out there need to assert ownership, individually or collectively to correct our relationship with the Internet and Web. We need a Web and Internet where we are co-owner and participant. I am no longer interested in being a tenant and product.



