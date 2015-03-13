
```
$ svn checkout http://youtube-as3-player-helper.googlecode.com/svn/trunk/ youtube-as3-player-helper-read-only
```

  * define FLEX\_HOME environment variable

```
$ export FLEX_HOME=/full-path-to/flex_sdk_4.5.0.20967
```

  * Download and install [Apache Ant](http://ant.apache.org/)

  * Build the project

```
$ ant 
Buildfile: youtube-as3-player-helper-read-only/build.xml

init:
    [mkdir] Created dir: youtube-as3-player-helper-read-only/build
    [mkdir] Created dir: youtube-as3-player-helper-read-only/build/dist

main:
    [compc] Loading configuration file .../flex_sdk_4.5.0.20967/frameworks/flex-config.xml
    [compc] youtube-as3-player-helper-read-only/build/dist/youtube_as3_player_helper.swc (7814 bytes)

BUILD SUCCESSFUL
Total time: 3 seconds
```

To run examples, simply open these files in a browser:
```
$ firefox build/examples/fullscreen/index.html

$ firefox build/examples/ChromelessPlayerExample.swf 

$ firefox build/examples/EmbeddedPlayerExample.swf 
```

On Mac, use "open" command instead of firefox:
```
$ open build/examples/fullscreen/index.html

$ open build/examples/ChromelessPlayerExample.swf 

$ open build/examples/EmbeddedPlayerExample.swf 
```