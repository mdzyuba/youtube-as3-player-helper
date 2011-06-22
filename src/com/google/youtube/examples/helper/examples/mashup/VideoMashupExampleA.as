/*
 * Copyright 2011 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 https://sites.google.com/site/lastcallforio2011/youtube-apis

 Task:

 Create a video mash-up by chaining player invocations.

 You will be given a list of video IDs, and from-to timestamps.
 For example the following sequence (<xxasdadad, 65s, 95s>,
 <xxffwwe22, 20s, 35s>), which will trigger the mash-up player to play video
 with ID xxasdadad for 30 seconds, starting at second 65 and ending at
 second 95, then proceed to play video with ID xxffwwe22, starting at second
 20 and ending at second 35.

 Given the sequence, implement a player which will play the sections of the
 listed videos, starting at the ‘from’ timestamp, and ending at the ‘to’
 timestamp for each video.

 Try to make the transitions between videos as smooth as possible, and make
 it easy for users to embed your mash-up player in their own web applications.

 Your delivery consists of :

 1. The source code.
 2. Link to a web site with example usage for sequence A and B below.

 We will provide you with :

 1. Video sequence A.
 (<u1zgFlCw8Aw, 22s, 28s>, <u1zgFlCw8Aw, 127s, 140s>, <L5ebSn9HgJ4, 3019s,
 3040s>, <u1zgFlCw8Aw, 195s, 199s>)

 */
package com.google.youtube.examples.helper.examples.mashup {

  import flash.display.Sprite;
  import flash.events.Event;

  [SWF(width = "1024", height = "768")]
  public class VideoMashupExampleA extends Sprite {

    private var sequence:Array = new Array(
        {videoId:"u1zgFlCw8Aw", start:"22", stop:"28"},
        {videoId:"u1zgFlCw8Aw", start:"127", stop:"140"},
        {videoId:"L5ebSn9HgJ4", start:"3019", stop:"3040"},
        {videoId:"u1zgFlCw8Aw", start:"195", stop:"199"}
    );

    public function VideoMashupExampleA() {
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
      var sequencePlayer:SequencePlayer = new SequencePlayer(sequence);
      addChild(sequencePlayer);
    }

  }
}
