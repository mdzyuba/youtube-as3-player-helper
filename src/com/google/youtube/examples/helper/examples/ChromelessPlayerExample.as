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

  import com.google.youtube.examples.helper.core.PlaybackQuality;
  import com.google.youtube.examples.helper.core.PlayerState;

  import flash.events.Event;

  [SWF(width = "640", height = "360", backgroundColor = "0x000000")]
  public class ChromelessPlayerExample extends PlayerExampleBase {
    private var videoId:String = "OxzucwjFEEs";
    public static const INITIAL_PLAYER_WIDTH:int = 640;
    public static const INITIAL_PLAYER_HEIGHT:int = 360;

    public function ChromelessPlayerExample() {
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
    }

    private function onAddedToStage(event:Event):void {
      playerLoader.loadChromelessVideoPlayer();
    }

    protected override function onPlayerReady(event:Event):void {
      super.onPlayerReady(event);
      playerLoader.player.setSize(INITIAL_PLAYER_WIDTH, INITIAL_PLAYER_HEIGHT);
      playerLoader.player.cueVideoById(videoId, 0, PlaybackQuality.MEDIUM);
    }

    protected override function onPlayerStateChange(event:Event):void {
      var youtubeEvent:Object = event;
      var playerState:Number = Number(youtubeEvent.data);
      // INFO: the player size is unknown in unstarted state
      pane.tracePlayerSize("ChromelessPlayerExample player state: " +
          PlayerState.toString(playerState));
      // INFO: The player quality is "small" in unstarted and cued states
      trace("info", "quality:", playerLoader.player.getPlaybackQuality());
      switch (playerState) {
        case PlayerState.CUED:
          pane.updatePlayerLocation();
          playerLoader.player.playVideo();
          break;
      }
    }
  }
}
