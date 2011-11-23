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

package com.google.youtube.examples.helper.examples.fullscreen {
  import com.google.youtube.examples.helper.core.PlaybackQuality;
  import com.google.youtube.examples.helper.core.PlayerEvent;
  import com.google.youtube.examples.helper.core.PlayerLoader;
  import com.google.youtube.examples.helper.core.PlayerState;

  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageDisplayState;
  import flash.display.StageScaleMode;

  import flash.events.Event;
  import flash.events.FullScreenEvent;
  import flash.events.MouseEvent;
  import flash.geom.Rectangle;
  import flash.text.TextField;

  import mx.controls.Button;

  [SWF(width = "640", height = "360", backgroundColor = "0xFFFFFF")]
  public class ChromelessPlayerFullScreenExample extends Sprite {
    public static const INITIAL_PLAYER_WIDTH:int = 640;
    public static const INITIAL_PLAYER_HEIGHT:int = 360;
    protected var playerLoader:PlayerLoader;
    private var controls:Sprite;
    private var videoId:String = "bHQqvYy5KYo";

    public function ChromelessPlayerFullScreenExample() {
      setupStage();
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
    }

    public function setupStage():void {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(FullScreenEvent.FULL_SCREEN, onFullScreenEvent);
    }

    private function onAddedToStage(event:Event):void {
      trace("info", "PlayerExample onAddedToStage");
      playerLoader = new PlayerLoader();
      playerLoader.addEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
      playerLoader.loadChromelessVideoPlayer();
    }

    protected function onPlayerReady(event:Event):void {
      trace("info", "PlayerExample onPlayerReady");
      addChild(playerLoader.player);
      controls = createPlayerControls();
      addChild(controls);
      playerLoader.removeEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
      playerLoader.player.addEventListener(PlayerEvent.STATE_CHANGE,
          onPlayerStateChange);
      playerLoader.player.addEventListener(PlayerEvent.ERROR,
          onPlayerError);
      playerLoader.player.setSize(INITIAL_PLAYER_WIDTH, INITIAL_PLAYER_HEIGHT);
      playerLoader.player.cueVideoById(videoId, 0, PlaybackQuality.MEDIUM);
    }

    protected function onPlayerStateChange(event:Event):void {
      var youtubeEvent:Object = event;
      var playerState:Number = Number(youtubeEvent.data);
      switch (playerState) {
        case PlayerState.CUED:
          updatePlayerLocation();
          playerLoader.player.playVideo();
          break;
      }
    }

    public function updatePlayerLocation():void {
      if (stage && playerLoader && playerLoader.player) {
        var nx:Number = (stage.stageWidth - playerLoader.player.width) / 2;
        var ny:Number = (stage.stageHeight - playerLoader.player.height) / 2;
        // in some cases, I am getting player size larger than the stage
        if (nx > 0 && ny > 0) {
          playerLoader.player.x = nx;
          playerLoader.player.y = ny;
        } else {
          // leaving the traces for further debugging
          trace("info", "stage size", stage.stageWidth, stage.stageHeight);
          trace("info", "player size: ", playerLoader.player.width,
              playerLoader.player.height);
          playerLoader.player.x = 0;
          playerLoader.player.y = 0;
        }

        controls.x = playerLoader.player.x;
        controls.y = playerLoader.player.y + playerLoader.player.height + 5;
      } else {
        trace("info", "stage is not ready yet");
      }
    }

    protected function onPlayerError(event:Event):void {
      trace("info", "error: ", event);
    }

    private function createPlayerControls():Sprite {
      var fullScreenButton:Sprite = createButton("Full Screen",
          onFullButtonClick);
      var pauseButton:Sprite = createButton("Pause",
          onPauseButtonClick);
      var playButton:Sprite = createButton("Play",
          onPlayButtonClick);
      var buttons:Sprite = new Sprite();
      buttons.addChild(playButton);
      buttons.addChild(pauseButton);
      buttons.addChild(fullScreenButton);
      var padding:Number = 3;
      var width:Number = 60;
      pauseButton.x = playButton.x + width + padding;
      fullScreenButton.x = INITIAL_PLAYER_WIDTH - width;
      return buttons;
    }

    private function createButton(label:String, clickHandler:Function):Sprite {
      var width:Number = 60;
      var height:Number = 20;
      var color:Number = 0xEFEFEF;
      var button:Sprite = new Sprite();
      button.graphics.beginFill(color);
      button.graphics.drawRect(0, 0, width, height);
      button.graphics.endFill();
      button.addEventListener(MouseEvent.CLICK, clickHandler);
      button.buttonMode = true;
      button.mouseChildren = false;
      var textField:TextField = new TextField();
      textField.text = label;
      button.addChild(textField);
      return button;
    }

    public function enableFullScreen():void {
      trace("enableFullScreen ...");
      var scaleRectangle:Rectangle = getFullScreenScaleRect();
      trace("scaleRectangle", scaleRectangle);
      this.stage.fullScreenSourceRect = scaleRectangle;
      this.stage.displayState = StageDisplayState.FULL_SCREEN;
      playerLoader.player.setPlaybackQuality(PlaybackQuality.HD1080);
    }

    private function getFullScreenScaleRect():Rectangle {
      var scaleRectangle:Rectangle =
          new Rectangle(playerLoader.player.x,
              playerLoader.player.y,
              playerLoader.player.width,
              playerLoader.player.height);
      return scaleRectangle;
    }

    private function onFullButtonClick(event:Event):void {
      enableFullScreen();
    }

    private function onFullScreenEvent(event:FullScreenEvent):void {
      if (!event.fullScreen) {
        playerLoader.player.setPlaybackQuality(PlaybackQuality.MEDIUM);
      }
    }

    private function onPauseButtonClick(event:Event):void {
      playerLoader.player.pauseVideo();
    }

    private function onPlayButtonClick(event:Event):void {
      playerLoader.player.playVideo();
    }
  }
}
