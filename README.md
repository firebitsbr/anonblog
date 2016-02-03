# AnonBlog
Easily publish blogs over the Tor network for anonymity, using a small, lightweight, and extremely secure webserver to prevent being deanonymized.

## Usage

Usage is simple - No installation required!

 - Linux: Just download, extract, and run `./main.sh start`!
     - **Optional:** You can change the port that the server uses by editing `config/abconfig`. The hidden service will always be accessible on port 80, no matter what port the server itself runs on.
 - Post to your blog by running `./bb.sh`. To add custom files, images, etc., put them under `site`.
