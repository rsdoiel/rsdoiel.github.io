---
title: Building Lagrange on Raspberry Pi OS
pubDate: 2024-05-10T00:00:00.000Z
author: R. S. Doiel
byline: 'R. S. Doiel, 2024-05-10'
copyrightYear: 2024
copyrightHolder: R. S. Doiel
license: 'https://creativecommons.org/licenses/by-sa/4.0/'
abstract: >
  These are my quick notes on building the Lagrange Gemini browser on Raspberry
  Pi OS. They are based on instructions I found at
  <gemini://home.gegeweb.org/install_lagrange_linux.gmi>. These are in French
  and I don't speak or read French. My loss. The author kindly provided the
  specific command sequence in shell that I could read those. That was all I
  needed. When I read the site today I had to click through an expired
  certificate. That's why I think it is a good idea to capture the instructions
  here for the next time I need them.  I made single change to his instructions.
  I have cloned the repository from <https://github.com/skyjake/lagrange>.


  ...
dateCreated: '2024-05-10'
dateModified: '2025-07-23'
datePublished: '2024-05-10'
postPath: 'blog/2024/05/10/building-lagrange-on-pi-os.md'
keywords:
  - Gopher
  - Gemini
  - Browsers
---

# Building Lagrange on Raspberry Pi OS

These are my quick notes on building the Lagrange Gemini browser on Raspberry Pi OS. They are based on instructions I found at <gemini://home.gegeweb.org/install_lagrange_linux.gmi>. These are in French and I don't speak or read French. My loss. The author kindly provided the specific command sequence in shell that I could read those. That was all I needed. When I read the site today I had to click through an expired certificate. That's why I think it is a good idea to capture the instructions here for the next time I need them.  I made single change to his instructions. I have cloned the repository from <https://github.com/skyjake/lagrange>.

## Steps to build

1. Install the programs and libraries in Raspberry Pi OS to build Lagrange
2. Create a directory to hold the repository, then change into it
3. Clone the repository
4. Add a "build" directory to the repository and change into it
5. Run "cmake" to build the release
6. Run "make" in the build directory and install
7. Test it out.

When you clone the repository you want to clone recursively and get the release branch. Below is a transcript of the commands I typed in my shell to build Lagrange on my Raspberry Pi 4.

~~~shell
sudo apt install build-essential cmake \
     libsdl2-dev libssl-dev libpcre3-dev \
     zlib1g-dev libunistring-dev git
mkdir -p src/github.com/skyjake && cd src/github.com/skyjake 
git clone --recursive --branch release git@github.com:skyjake/lagrange.git
mkdir -p lagrange/build && lagrange/build
cmake ../ -DCMAKE_BUILD_TYPE=Release
sudo make install
lagrange &
~~~

That's about it. It worked without a hitch. I'd like to thank Gérald Niel who I think created the page on gegeweb.org. I attempted to leave a thank you via the web form but couldn't get past the spam screener since I didn't understand the instructions. C'est la vie.
