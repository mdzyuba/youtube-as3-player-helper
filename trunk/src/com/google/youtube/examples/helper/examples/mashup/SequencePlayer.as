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

package com.google.youtube.examples.helper.examples.mashup {

  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;

  public class SequencePlayer extends Sprite {
    private var player:ClipPlayer;
    private var sequence:Array;
    private var currentClipIndex:Number = 0;

    public function SequencePlayer(sequence:Array) {
      this.sequence = sequence;
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      addEventListener(Event.RESIZE, onResize);
      var videoClip:Object = sequence[currentClipIndex];
      player = new ClipPlayer(videoClip.videoId, videoClip.start,
          videoClip.stop);
      player.addEventListener(ClipPlayer.EVENT_CLIP_IS_READY, onPlayerReady);
      player.addEventListener(ClipPlayer.EVENT_CLIP_FINISHED, onPlayerFinish);
      addChild(player);
    }

    private function onAddedToStage(event:Event):void {
      trace("info", "SequencePlayer is added to stage",
          EventUtil.phaseName(event.eventPhase));
      setupStage();
    }

    private function onPlayerReady(event:Event):void {
      updatePlayerLocation();
      player.play();
    }

    private function onPlayerFinish(event:Event):void {
      trace("info", "now is a time to show another clip");
      currentClipIndex++;
      if (currentClipIndex < sequence.length) {
        var videoClip:Object = sequence[currentClipIndex];
        player.cueVideoAndScheduleStop(videoClip.videoId, videoClip.start,
            videoClip.stop);
      } else {
        player.pause();
      }
    }

    private function setupStage():void {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.RESIZE, onStageResize);
    }

    private function onEnterFrame(event:Event):void {
      removeEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function updatePlayerLocation():void {
      if (this.stage && player.playerLoader.player) {
        var x:Number = (this.stage.stageWidth -
            player.playerLoader.player.width) / 2;
        var y:Number = (this.stage.stageHeight -
            player.playerLoader.player.height) / 2;
        player.playerLoader.player.x = x;
        player.playerLoader.player.y = y;
      } else {
        trace("info", "stage is not ready yet");
      }
    }

    private function onResize(event:Event):void {
      trace("info", "VideoMashupExample resize", this.getBounds(this.stage));
    }

    private function onStageResize(event:Event):void {
      trace("info", "stage resize: ", this.stage.getBounds(this));
      updatePlayerLocation();
    }
  }
}
