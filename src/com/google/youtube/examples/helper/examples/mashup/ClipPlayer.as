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

  import com.google.youtube.examples.helper.core.PlaybackQuality;
  import com.google.youtube.examples.helper.core.PlayerEvent;
  import com.google.youtube.examples.helper.core.PlayerLoader;
  import com.google.youtube.examples.helper.core.PlayerState;

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import flash.utils.getTimer;

  [Event(name = ClipPlayer.EVENT_CLIP_IS_READY, type = "flash.events.Event")]
  [Event(name = ClipPlayer.EVENT_CLIP_STARTED, type = "flash.events.Event")]
  [Event(name = ClipPlayer.EVENT_CLIP_FINISHED, type = "flash.events.Event")]
  [Event(name = ClipPlayer.EVENT_CLIP_LOAD_ERROR, type = "flash.events.Event")]

  public class ClipPlayer extends Sprite {

    public static const EVENT_CLIP_IS_READY:String = "clipReady";
    public static const EVENT_CLIP_STARTED:String = "clipStart";
    public static const EVENT_CLIP_FINISHED:String = "clipFinish";
    public static const EVENT_CLIP_LOAD_ERROR:String = "clipError"

    private var playerLoaderValue:PlayerLoader;
    private var videoIdValue:String;
    private var timeStartValue:Number;
    private var timeEndValue:Number;
    private var timer:Timer;

    public function ClipPlayer(videoId:String, timeStart:Number,
        timeEnd:Number) {
      trace("info", "creating ClipPlayer");
      this.videoId = videoId;
      this.timeStartValue = timeStart;
      this.timeEndValue = timeEnd;
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
      this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
      addEventListener(Event.RESIZE, onResize);
    }

    private function createPlayerLoader():void {
      playerLoaderValue = new PlayerLoader();
      playerLoader.addEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
      playerLoader.loadChromelessVideoPlayer();
    }

    private function onPlayerReady(event:Event):void {
      trace("info", "PlayerReady: ", EventUtil.phaseName(event.eventPhase));
      addChild(playerLoader.player);
      if (playerLoader != null && playerLoader.player != null) {
        playerLoader.player.removeEventListener(PlayerEvent
            .PLAYER_IS_READY, onPlayerReady);
        playerLoader.addEventListener(Event.ADDED_TO_STAGE,
            onPlayerLoaderAddedToStage);
        playerLoader.addEventListener(Event.RESIZE, onPlayerLoaderResize);
        playerLoader.player.addEventListener(PlayerEvent.STATE_CHANGE,
            onPlayerStateChange);
        playerLoader.player.addEventListener(PlayerEvent.ERROR,
            onPlayerError);
        playerLoader.player.addEventListener(Event.RESIZE, onPlayerResize);
        cueVideoAndScheduleStop(this.videoId, this.timeStartValue,
            this.timeEndValue);
      }
    }

    public function cueVideoAndScheduleStop(videoId:String, timeStart:Number,
        timeEnd:Number):void {
      if (playerLoader.player) {
        playerLoader.player.unmute();
      }
      trace("info", "cue video", videoId, timeStart, timeEnd);
      this.videoId = videoId;
      this.timeStartValue = timeStart;
      this.timeEndValue = timeEnd;
      playerLoader.player.cueVideoById(videoId, timeStart,
          PlaybackQuality.HD720);
    }

    private function setupTimer(start:Number, end:Number):void {
      var delay:Number = Math.abs(start - end) * 1000;
      trace("info", "scheduing timer for ", delay, "ms");
      timer = new Timer(delay);
      timer.addEventListener(TimerEvent.TIMER, onTimeComplete);
    }

    private function onPlayerStateChange(event:Event):void {
      var youtubeEvent:Object = event;
      var playerState:Number = Number(youtubeEvent.data);
      trace("info", "state: " + PlayerState.toString(playerState));
      switch (playerState) {
        case PlayerState.UNSTARTED:
          break;
        case PlayerState.BUFFERING:
          break;
        case PlayerState.PLAYING:
          var actualStartTime:Number = playerLoader.player.getCurrentTime();
          trace("info", "starting the timer", "player time: ", actualStartTime,
              "expected start time:", this.timeStartValue,
              "swf time: ", getTimer());
          // the actual start time could be different than the scheduled start
          // time. updating the delay to make sure we reach the scheduled end
          // time.
          setupTimer(actualStartTime, timeEnd)
          timer.start();
          dispatchEvent(new Event(ClipPlayer.EVENT_CLIP_STARTED));
          break;
        case PlayerState.PAUSED:
          break;
        case PlayerState.CUED:
          trace("info", "video ", this.videoId,
              " is cued, the start time now is ",
              playerLoader.player.getCurrentTime(),
              "expected start time:", this.timeStartValue);
          dispatchEvent(new Event(ClipPlayer.EVENT_CLIP_IS_READY));
          break;
        case PlayerState.ENDED:
          break;
        default:
          break;
      }
    }

    public function play():void {
      trace("info", "player.playVideo");
      playerLoader.player.playVideo();
    }

    private function onPlayerError(event:Event):void {
      trace("info", "error: ", event);
      dispatchEvent(new Event(ClipPlayer.EVENT_CLIP_LOAD_ERROR));
    }

    public function pause():void {
      playerLoader.player.pauseVideo();
    }

    private function onTimeComplete(event:TimerEvent):void {
      trace("info", "timer 1 is done");
      timer.stop();
      var playTime:Number = playerLoader.player.getCurrentTime();
      trace("info", "play time: ", playTime, "expected finish time:",
          this.timeEndValue, "swf time: ", getTimer());
      stopVideo();
    }

    private function stopVideo():void {
      playerLoader.player.mute();
      trace("info", "stopping the video ... ",
          "timer: ", getTimer());
      dispatchEvent(new Event(ClipPlayer.EVENT_CLIP_FINISHED));
    }

    public function get playerLoader():PlayerLoader {
      return playerLoaderValue;
    }

    private function onPlayerLoaderAddedToStage(event:Event):void {
      trace("info", "player loader event: ", event.type);
    }

    private function onAddedToStage(event:Event):void {
      trace("info", "ClipPlayer is added to stage",
          EventUtil.phaseName(event.eventPhase));
      if (playerLoader == null) {
        createPlayerLoader();
      }
    }

    private function onRemovedFromStage(event:Event):void {
      trace("info", "ClipPlayer is removed from stage",
          EventUtil.phaseName(event.eventPhase));
    }

    private function onPlayerLoaderResize(event:Event):void {
      trace("info", "player loader event: ", event.type);
    }

    private function onResize(event:Event):void {
      trace("info", "ClipPlayer resize", this.getBounds(this.stage));
    }

    public function get videoId():String {
      return videoIdValue;
    }

    public function set videoId(value:String):void {
      videoIdValue = value;
    }

    public function get timeStart():Number {
      return timeStartValue;
    }

    public function set timeStart(value:Number):void {
      timeStartValue = value;
    }

    public function get timeEnd():Number {
      return timeEndValue;
    }

    public function set timeEnd(value:Number):void {
      timeEndValue = value;
    }

    private function onPlayerResize(event:Event):void {
      trace("info", "player resized: ", this.playerLoader.player.width,
          this.playerLoader.player.height);
    }
  }

}
