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

  import flash.events.Event;

  [SWF(width = "640", height = "390")]
  public class EmbeddedPlayerExample extends PlayerExampleBase {
    private var videoId:String = "bHQqvYy5KYo";

    public function EmbeddedPlayerExample() {
      this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage)
    }

    private function onAddedToStage(event:Event):void {
      playerLoader.loadEmbeddedVideoPlayer(videoId);
    }

    override protected function onPlayerReady(event:Event):void {
      super.onPlayerReady(event);
      playerLoader.player.setPlaybackQuality(PlaybackQuality.MEDIUM);
      playerLoader.player.playVideo();
    }
  }
}
