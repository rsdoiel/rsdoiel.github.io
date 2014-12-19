
# Technical details for non-technical web managers


The web is a technical thing that the majority of the public sees as a utility much like the telephone, television or electricity available from an eletrical outlit. The primary experience is through the web browser or other application.  But the web itself it built from some specificly technical things just as an automobile is made of of physical parts. So what is the web?

## the foundation is protocol

The web is a human using a computing device interacting with another computing device.  The human be using a phone, a tablet, a laptop, their TV, sterio their car, or even a sprinkler system. The common aspect in all of these is a computer which is contacting another computer to achieve a goal (e.g. watch a movie, lookup a recipe, find directions, writing a letter, turn on or off sprinklers).  Specific to the web is a standard set of ways for the computing devices to talk to another another.  The way two or more computers talk to each is through a _prototocal_ over a communications network. There are five important protocols as of 2014 used on the web.

### http/https

The first two and most common protocols are _http_ (hyper text transport protocol) and _https_ (hyper-text transport protocol secure).  These two protocols establish the expectations for the content that will be exchange between two computers.  The basic flow of the protocol is from the human run computer contacting the other computer saying what resource it desires to see along with specific information about the forms of the resource it understands.  As an example a humam may want to read an blog post and their computer tells the computer that has the blog post that it would like the article text and any images or movies that it contains.  Another computer may ask for the same article but only for the plain text. It is up the the computer where the blog article is to agree and send back content as best it can.  It it cannot comply with the request it will try to send that information back too.

Notice that the human doesn't normally see these details. They put in the URL into their web browser and see a webpage with the text and videa.  The extra information is exchanged through what technical people called _headers_ or _http headers_. If you look at this as the computer sees it you would see a series of preditable sentences (lines of text) each having a specific meaning for the sending and recieving computer.

What's the difference between _http_ and _https_? The _http_ protocol is what is called a plain text transport protocol. This means anyone watching the data flowing between two computers can easily read the contents of the transmition.  Assuming you are not transmitting confidential, sensitive or secret information this is probably fine.  If you want to confidentially retrieve web content then you want to have the communications encrypted between the two computers. 

How do you choose between _http_ and _https_ protocols? The short answer is use _https_ whenever it is available. The long answer is use it anytime you are transmitting confidential, private or secret information you need to use the _https_ protocol. The obvious cases are things like passwords, creditcard or banking information. The less obvious cases are searches and research you perform that reflect your private matters.  Two use cases highlights. Let's say you researching your vacation. You will need to know the hotel prices for a specific time of the year. Someone watching this now knows your home will likely be unoccupied during those times.  Anther common case is researching a new job or health information. Do you which that to be public?  If you are using _http_ it is public. Someone can see it easily.  That is why the general rule of thumb is use _https_ if it is available. It is safer even when accessing normally public content.

Are their limits to _https_?  Yes, all encryption can be broken quickly given enough resources. Today resources are cheap for the well funded. This includes businessnes, governments and criminal organizations.  _https_ is like locking the doors of your home.  Some group who is determined will either break the door or pick the lock but for most cases it discorages people from walking in unwelcomed.

### SPDY

Google serves allot of web content and consumes even more.  They realized that the _http_ protocol and _https_ protocol can be in-efficient for some situations. They developed an improved version called _SPDY_ (spoken "speedy").  They made the protocol public and many web services now support this protocol as well as _http_ and _https_. In the long run this protocol is serving as a test bed for improved versions of _http_  and _https_.

### Web Sockets

The protocols mention so far are called asynchonious protocols. This means there can be a long time between the computers making a request and receiving a response. If a computer makes multiple requests their is no guarantee of the order those responses will be returned.  Most of the time this is OK.  Sometimes you want to have synchronious communication. An example would be text, audio and video or chat services. It could also include information like stock price updates and traffic information.  Synchronious communications support active conversations between the computers without having to renegitiate the terms of the communication at each exchange.  _Web Sockets_ is an early way to implement this. It requires that the two computers communicating both support this. Additionally the content of the web page needs to be setup such that this can be supported too (e.g. via JavaScript).

### WebRTC

_WebRTC_ stands for Web Realtime Communication.  It is built off the previous protocols but allows two computers to communication directly in a peer-to-peer fashion. This includes test, audio, and video chat services or even shared editing of documents.  Historically if two people wanted to interact with each other through a web page it involved three computers. Each human had their device and a third hosting the service would pass the information between them. With WebRTC the third computer helps the two connect but then leaves it up to the two to talk directly with each other. This frees the third computer and its network up for other uses.

## the web is built from documents and their types


Before the web their was _hypertext_.  _Hypertext_ was normal textual information plus a way to link that information together. It grew from the paper tradition of foot note, end notes and references.  On paper these got relageted to the end of the page, chapter or book. They were constrained by those deminsions. When computer arrived on the computers screens in the 1950s the container changed. By the 1960s efforts to take advantage of this eventually resulting in the concept of linked documents. This intern, with the help of Sir Tim Burnes-Lee, evolved into the web link we use today.  The document structure that Sir Tim created was called HTML.  Today we use the fifth version of that document structure and we can do a whole lot more than just link pages together.  The web would not be the web without _http/https_ protocol and _HTML_ documents.  It is these two things that pull everything together.

In addition to _HTML_ documents five other documents types are important to the modern web and let us experience it beyond single linked pages but as applications, realtime communication and even as operating systems for laptops and phones.

+ CSS
+ JavaScript
+ JSON
+ XML documents (e.g. RSS feeds)
+ Other media (e.g. movies, audio recordings, flash, images)


