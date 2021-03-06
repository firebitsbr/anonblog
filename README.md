## CURRENTLY ON DEVELOPMENTAL HIATUS. NOT MAINTAINED.

![Anonblog logo](http://i.imgur.com/tJMcQqs.png)

[AnonBlog](https://chaoswebs.net/anonblog/) is an easy way to anonymously publish blogs and static sites over the Tor network, using a small, lightweight, and secure web server.

The goal of this project is to be secure, lightweight, & simple, while maintaining easy portability to all Unix based systems.

When hosting static websties, AnonBlog has many advantages due to its lightweight nature. 

AnonBlog has no complex features or bloat that Apache, Lighttpd, and Nginx have, which are often how many hidden services are compromised.

**Before using or contributing to this project, please fully read everything here**.

## Download Binary Release

**This software is no longer maintained, do not use. May be brought back with better security & features in the future**

It is recommended that you build the software yourself, but a compiled release is available, [here](https://github.com/beardog108/anonblog/releases).

## Usage

Usage is simple - No installation required!

 - Linux: Just download, extract, and run `./main.sh start`!
     - **Optional:** You can change the port that the server uses by editing `config/abconfig`. The hidden service will always be accessible on port 80, no matter what port the server itself runs on.
 - Post to your blog by running `./bb.sh`. To add custom files, images, etc., put them under `site`. (You can also put any other files you want there.)
- [See here for more information regarding using bashblog.](https://github.com/cfenollosa/bashblog)
- The server runs in the foreground by default, to run as a background process do 'nohup ./main.sh start & disown'

The current release is for standard x86-64 processors, but it can be compiled for x86 and ARM systems such as the [Raspberry Pi](https://www.raspberrypi.org/).

**AnonBlog supports a limited amount of file extensions, see FILE-TYPES.txt**

## Warning - *Important Info*

AnonBlog is in beta right now, while we believe it is "pretty good", you should never bet your life or liberty on software, especially software in early development.


**ALSO**:

- This software is intended to host only static blogs/sites. This software can not be used for things like forums, chat rooms, etc. that require server-side capabilities.

- Also, Tor its self is vulnerable to correlation/timing attacks, which may unmask you and your visitors. Tor may also be vulnerable to other unknown attacks.

 - In any case, the longer a hidden service is hosted, the higher its chance of being compromised is, regardless of the server software it is running.

- Your sites content, writing style, regional language, slang, dialects, and more may point to your relative geographic location.

- You should write as generically and normally as possible, as any quirks may help to unmask you. Remember, many Tor users are compromised through standard detective work, not just tech hacking.

- Note: Your ISP/others can generally see that you are using the Tor network (but not what you do with it), this is not a major deal in "more free" countries, but in some areas this may warrant suspicion of your activites.

- Hidden services can also be discovered by bad Tor nodes (their existence, not nessasarily their location). This is a limitation in the Tor network rather than in Anonblog.

- Be sure to scrub any images/other files of metadata before publishing them, [see here for more info](https://en.wikipedia.org/wiki/Exif#Privacy_and_security).


**For more information regarding Tor hidden services, see https://www.torproject.org/docs/hidden-services.html.en.**


## Contributing

Anyone that knows shell scripting, C, or in depth Tor knowledge is welcome to contribute. Get in touch with us if you are contributing non-trivial changes.

## Building

The current build is for x86-64 processors

The web server source is in src/bbserver.c

It can be built using GCC 5.8.6 (other versions/compilers untested)

It is **highly** recommended that you build the source code yourself, both of our web server and Tor.

The Tor source code can be obtained [here](https://www.torproject.org/download/download.html.en).

If you build Tor, replace the Tor binary in bin/, 'tor' if your machine is 32-bit and 'tor64' if your machine is 64-bit (x86 architecture)

## Donate

![BTC logo](https://en.bitcoin.it/w/images/en/8/8c/RibbonDonateBitcoin.png)

If you have some satoshi to spare, consider sending us a tip:

137aLmDHUCJKv7s8yzNBZ6dE2erob55YF5

## Get In Touch

[Contact us if you have any questions or want to contribute](https://chaoswebs.net/?page=contact).


## Thanks to:

- [The Tor Project](https://torproject.org/), for creating Tor.
- Nigel Griffiths (nag@uk.ibm.com), for creating the web server 'Nweb' (bbserver is based on Nweb)
- All who contributed to [Bashblog](https://github.com/cfenollosa/bashblog), a static blog generator included with AnonBlog.
- [Kevin Froman](https://chaoswebs.net/?page=about) and [Duncan X. Simpson](https://www.k7dxs.xyz/), the main AnonBlog devs.


Copyright &copy; 2016 Kevin Froman and Duncan X. Simpson. See the license file for more information. Tor & the Onion logo are registered trademarks of The Tor Project, Inc. This software is not endorsed by or affiliated with The Tor Project, Inc.
