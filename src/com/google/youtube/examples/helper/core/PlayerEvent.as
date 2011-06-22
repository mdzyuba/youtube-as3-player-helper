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

/**
 * Player Events.
 */
package com.google.youtube.examples.helper.core {

  import flash.events.Event;

  public class PlayerEvent extends Event {
    public static const PLAYER_IS_READY:String = "onReady";
    public static const STATE_CHANGE:String = "onStateChange";
    public static const ERROR:String = "onError";
    public static const PLAYBACK_QUALITY_CHANGE:String =
        "onPlaybackQualityChange";
    public static const UNKNOWN_ERROR_CODE:Number = -1;

    private var sourceValue:Event;

    public function PlayerEvent(type:String, source:Event,
        bubbles:Boolean = false, cancelable:Boolean = false) {
      super(type, bubbles, cancelable);
      sourceValue = source;
    }

    public function get source():Event {
      return sourceValue;
    }

    public function get errorCode():Number {
      if (source.hasOwnProperty("data")) {
        var errorCode:Number = Number(source["data"]);
        return errorCode;
      }
      return UNKNOWN_ERROR_CODE;
    }

    public override function clone():Event {
      return new PlayerEvent(type, sourceValue, bubbles, cancelable);
    }
  }
}
