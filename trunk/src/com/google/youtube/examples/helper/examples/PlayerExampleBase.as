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

  import com.google.youtube.examples.helper.core.PlayerEvent;
  import com.google.youtube.examples.helper.core.PlayerLoader;

  import flash.display.Sprite;
  import flash.events.Event;

  public class PlayerExampleBase extends Sprite {
    protected var playerLoader:PlayerLoader;
    private var paneValue:PlayerPane;

    public function PlayerExampleBase() {
      addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
    }

    private function onAddedToStage(event:Event):void {
      trace("info", "PlayerExample onAddedToStage");
      playerLoader = new PlayerLoader();
      paneValue = new PlayerPane(playerLoader);
      playerLoader.addEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
    }

    protected function onPlayerReady(event:Event):void {
      trace("info", "PlayerExample onPlayerReady");
      addChild(pane);
      playerLoader.removeEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
      playerLoader.player.addEventListener(PlayerEvent.STATE_CHANGE,
          onPlayerStateChange);
      playerLoader.player.addEventListener(PlayerEvent.ERROR,
          onPlayerError);
    }

    protected function onPlayerStateChange(event:Event):void {
      // overwrite this method in a specific example
    }

    protected function onPlayerError(event:Event):void {
      trace("info", "error: ", event);
    }

    public function get pane():PlayerPane {
      return this.paneValue;
    }

  }
}
