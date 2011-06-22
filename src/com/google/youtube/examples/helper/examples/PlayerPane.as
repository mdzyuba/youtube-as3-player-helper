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

package com.google.youtube.examples.helper.examples {

  import com.google.youtube.examples.helper.core.PlayerLoader;

  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;

  public class PlayerPane extends Sprite {
    private var playerLoader:PlayerLoader;

    public function PlayerPane(playerLoader:PlayerLoader) {
      this.playerLoader = playerLoader;
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
      setupStage();
      addChild(this.playerLoader.player);
      updatePlayerLocation();
    }

    public function setupStage():void {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      stage.addEventListener(Event.RESIZE, onStageResize);
    }

    private function onStageResize(event:Event):void {
      if (playerLoader && playerLoader.player) {
        playerLoader.player.setSize(stage.stageWidth, stage.stageHeight);
        updatePlayerLocation();
      }
    }

    public function updatePlayerLocation():void {
      if (stage && playerLoader && playerLoader.player) {
        var nx:Number = (stage.stageWidth - playerLoader.player.width) / 2;
        var ny:Number = (stage.stageHeight - playerLoader.player.height) / 2;
        // in some cases, I am getting player size larger than the stage
        if (nx > 0 && ny > 0) {
          x = nx;
          y = ny;
        } else {
          // leaving the traces for further debugging
          trace("info", "stage size", stage.stageWidth, stage.stageHeight);
          trace("info", "player size: ", playerLoader.player.width,
              playerLoader.player.height);
          x = 0;
          y = 0;
        }
      } else {
        trace("info", "stage is not ready yet");
      }
    }

    public function tracePlayerSize(msg:String = ""):void {
      trace("info", msg);
      if (playerLoader && playerLoader.player) {
        trace("info", "player size: ", playerLoader.player.width,
            playerLoader.player.height);
      }
    }
  }
}
