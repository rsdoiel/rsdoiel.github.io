Notes on compiling PhantomJS on a Raspberry Pi
==============================================

Raspian does not include a standalone debian package for PhantomJS.  It does have instructions on how
to build on a Debian distrabution. So using that as a starting point I decided if my little
Raspberry Pi could compile PhantonJS so I can play around with it as a pre-render engine under NodeJS.

1) Followed the simple clear instructions at http://phantomjs.org/build.html

1b) Result when I get to ./build.sh step knowing happens.  Looking at the script there is a line where
the build process establishes how many CPUs are available.  It looks for lines starting with 'processor'.
When I check /info/cpuinfo on my Raspberry Pi I notice that Processor is capitalized.  I modify the line
containing @grep -c ^processor /proc/cpuinfo@ adding a @-i@ flag to the args.

```shell
    grep -ic ^processor /proc/cpuinfo
```

Retry @./build.sh@ and compilation starts.



