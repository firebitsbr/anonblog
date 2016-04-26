![Anonblog logo](http://i.imgur.com/tJMcQqs.png)

Anonblog is an easy way to anonymously publish blogs/static sites over the Tor network, using a small, lightweight, and secure webserver to prevent being deanonymized.

The goal of this project is to be secure, lightweight, & simple, while maintaining easy portability to all Unix based systems.

**Before using or contributing to this project, please fully read everything here**.

## Usage

Usage is simple - No installation required!

 - Linux: Just download, extract, and run `./main.sh start`!
     - **Optional:** You can change the port that the server uses by editing `config/abconfig`. The hidden service will always be accessible on port 80, no matter what port the server itself runs on.
 - Post to your blog by running `./bb.sh`. To add custom files, images, etc., put them under `site`. (You can also put any other files you want there.)
- [See here for more information regarding using bashblog.](https://github.com/cfenollosa/bashblog)

The current build is for x86-64 proccessors.

## Warning - *Important Info*

Anonblog is in alpha right now, while we believe it is "pretty good", you should never bet your life or liberty on software, especially software in early development.


**ALSO**:

- This software is intended to host only static blogs/sites. This software has not been tested for things like forums, chat rooms, etc.

- Also, Tor its self is vulnerable to correlation/timing attacks, which may unmask you and your visitors. Tor may also be vulnerable to other unknown attacks.

 - In any case, the longer a hidden service is hosted, the higher its chance of being compromised is, regardless of the server software it is running.

- Your sites content, writing style, regional language, slang, dialects, and more may point to your relative geographic location.

- Note: Your ISP/others can generally see that you are using the Tor network (but not what you do with it), this is not a major deal in "more free" countries, but in some areas this may warrant suspicion of your activites.

- Hidden services can also be discovered by bad Tor nodes (their existence, not nessasarily their location). This is a limitation in the Tor network rather than in Anonblog.

- Be sure to scrub any images/other files of metadata before publishing them.


**For more information regarding Tor hidden services, see [here](https://www.torproject.org/docs/hidden-services.html.en).**


## Contributing

Anyone that knows shell scripting, C, or in depth Tor knowledge is welcome to contribute here.

## Building

The current build is for x86-64 proccessors

The webserver source is in src/bbserver.c

It can be built using GCC 5.8.6 (other versions/compilers untested)

## Donate

![BTC logo](http://i.imgur.com/UQsoecv.png)

Tip us coffee money to motivate us to keep doing what we do:

137aLmDHUCJKv7s8yzNBZ6dE2erob55YF5


## Thanks to:

- [The Tor Project](https://torproject.org/) for creating Tor.
- Nigel Griffiths (nag@uk.ibm.com) for creating Nweb (bbserver is based on Nweb)
- All who contributed to [Bashblog](https://github.com/cfenollosa/bashblog), a static blog generator included with AnonBlog.
- [Kevin Froman](https://chaoswebs.net/?page=about) and [Duncan Simpson](https://k7dxs.xyz/), the main AnonBlog devs.


Tor & the Onion logo are registered trademarks of The Tor Project, Inc. This software is not endorsed by or affiliated with The Tor Project, Inc.
