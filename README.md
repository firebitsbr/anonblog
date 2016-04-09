# ☠ AnonBlog ☠
Anonblog lets you asily publish blogs/static sites over the Tor network for anonymity, using a small, lightweight, and extremely secure webserver to prevent being deanonymized.

## Usage

Usage is simple - No installation required!

 - Linux: Just download, extract, and run `./main.sh start`!
     - **Optional:** You can change the port that the server uses by editing `config/abconfig`. The hidden service will always be accessible on port 80, no matter what port the server itself runs on.
 - Post to your blog by running `./bb.sh`. To add custom files, images, etc., put them under `site`. (You can also put any other files you want there.)
- [See here for more information regarding using bashblog (You can use markdown 😁)](https://github.com/cfenollosa/bashblog)
- 


## Warning

Tor is not fool proof, & although we believe this software to be better 'out of the box' than Apache/similar for .onion blogs, something may still go wrong and compromise your identity. Please keep this in mind.

Also, Tor its self is vulnerable to correlation attacks, which may unmask you and your visitors.
