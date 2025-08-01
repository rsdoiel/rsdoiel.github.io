---
title: A quick review of Raspberry Pi Connect
byline: 'R. S. Doiel, 2024-05-10'
keywords:
  - raspberry pi
  - connect
  - realvnc
pubDate: 2024-05-10T00:00:00.000Z
author: R. S. Doiel
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: |
  A review of Raspberry Pi Connect as an alternative to using RealVNC.
dateCreated: '2024-05-10'
dateModified: '2025-07-23'
datePublished: '2024-05-10'
---

# A quick review of Raspberry Pi Connect

The Raspberry Pi company has created a nice way to share a Pi Desktop. It is called Raspberry Pi Connect. It is built on the peer-to-peer capability of modern web browsers using [WebRTC](https://en.wikipedia.org/wiki/WebRTC). The connect service requires a Raspberry Pi 4, Raspberry Pi 400 or Raspberry Pi 5 running the [Wayland](https://en.wikipedia.org/wiki/Wayland_(protocol)) display server and Bookworm release of Raspberry Pi OS.

When I read the [announcement](https://www.raspberrypi.com/news/raspberry-pi-connect/) I wondered, why create Raspberry Pi Connect? RealVNC has works fine.  RealVNC even has a service to manage your RealVNC setups.

I think the answer has three parts. First it gives us another option for sharing a Pi Desktop. Second it is a chance to make things easier to use. Third if you can share a desktop using WebRTC then you can also provide additional services.

For me the real motivator is ease of use. In the past when I've used RealVNC between two private networks I've had to setup SSH tunneling. Not unmanageable but certainly not trivial.  I think this is where Raspberry Pi Connect shines. Setting up sharing is a three step process.

1. Start up your Pi desktop, install the software
2. Create a Raspberry Pi Connect account and register your Pi with the service
3. On another machine point your web browser at the URL for Raspberry Pi connect and press the connect button

The next time you want to connect you just turn on your Pi and login. If I have my Pi desktop to auto login then I just turn the Pi on and when it finishes booting it is ready and waiting. On my other machine I point my web browser at the connect website, login and press the connection button.

When I change computers I don't have to install VNC viewers. I don't have to worry about setting secure ssh tunnels. I point my web browser at the Raspberry Pi Connect site, login and press the connect button. The "one less thing to worry about" can make it feel much less cumbersome.

## How does it work?

The Raspberry Pi Connect architecture is intriguing. It leverages [WebRTC](https://developer.mozilla.org/en-US/docs/Web/API/WebRTC_API). WebRTC supports peer to peer real time connection between two web browsers running in separate locations across the internet. Making a WebRTC requires the two sites to use a URL to establish contact. From that location perform some handshaking and see if the peer connection can be establish a directly between the two locations. If the direct connection can't be established then a relay or proxy can be provided as a fallback. 

The Raspberry Pi Connect site provides the common URL to contact. On the Pi desktop side a Wayland based service provides access to the Pi's desktop. On the other side you use a Web Browser to display and interact with the desktop. Ideally the two locations can establish a direct connection. If that is not possible then Raspberry Pi Connect hosts [TURN](https://en.wikipedia.org/wiki/Traversal_Using_Relays_around_NAT) in London as a fallback. A direct connection gives you a responsive shared desktop experience but if you're on the Pacific edge of North America or on a remote Pacific island then traffic being relayed via London can be a painfully slow experience.

The forum for the Raspberry Pi Connect has a [topic](https://forums.raspberrypi.com/viewtopic.php?t=370591&sid=61d7cdf3c03a7ead49e3da837b0d4f06) discussing the routing algorithm and choices. The short version is exerted below.

> Essentially, when the connection was being established both sides provided their internet addresses (local, and WAN) - and when both sides tested their ability to talk to the other side, they failed. Only after this failure is the TURN server used.

## Questions

Can I replace RealVNC with Raspberry Pi Connect?

It depends. I still use Raspberry Pi 2, 3 and some Zeros. I'm out of luck using Pi Connect since these devices aren't supported. If you've already installed RealVNC and it's working well for you then sharing via Pi connect is less compelling.

If I was setting up a new set of Raspberry Pi 4/400 or 5s then I'd probably skip RealVNC and use Pi connect. It's feels much easier and unless the network situation forces you to route traffic through London is reasonably responsive.

Is screen sharing the only thing Raspberry Pi Connect provides?

I expect if Raspberry Pi Connect proves successful we'll see other enhancements. One of the ones mentioned in the forums was SSH services without the hassle of dealing with setting up tunnels. The folks in the Raspberry Pi company, foundation and community are pretty creative. It'll be interesting to see where this leads.