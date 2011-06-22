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

 2. Video sequence B.
 (<yFhFu25TGxM, 2s, 10s>, <tgGxi3hiOnY, 00s, 11s>, <B4Y_2V5caQk, 23s, 33s>,
 <x5tj9uSc2_4, 8s, 29s>)

 */
package com.google.youtube.examples.helper.examples.mashup {

  import flash.display.Sprite;
  import flash.events.Event;

  [SWF(width = "640", height = "480")]
  public class VideoMashupExampleB extends Sprite {

    private var sequence:Array = new Array(
        {videoId:"yFhFu25TGxM", start:"2", stop:"8"},
        {videoId:"tgGxi3hiOnY", start:"0", stop:"10.8"},
        {videoId:"B4Y_2V5caQk", start:"24", stop:"33.6"},
        {videoId:"x5tj9uSc2_4", start:"9", stop:"36.4"}
    );

    public function VideoMashupExampleB() {
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
      var sequencePlayer:SequencePlayer = new SequencePlayer(sequence);
      addChild(sequencePlayer);
    }

  }
}
