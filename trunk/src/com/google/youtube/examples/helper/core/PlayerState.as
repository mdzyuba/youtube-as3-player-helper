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

package com.google.youtube.examples.helper.core {
  public class PlayerState {
    public static const UNSTARTED:int = -1;
    public static const ENDED:int = 0;
    public static const PLAYING:int = 1;
    public static const PAUSED:int = 2;
    public static const BUFFERING:int = 3;
    public static const CUED:int = 5;

    private static const STATE_NAMES:Object = {
        "-1": "unstarted",
        "0": "ended",
        "1": "playing",
        "2": "paused",
        "3": "buffering",
        "5": "cued"
    };

    public static function toString(stateCode:Number):String {
      var stateName:String = (stateCode in STATE_NAMES) ?
          STATE_NAMES[stateCode] : "unknown(" + stateCode + ")";
      return stateName;
    }
  }
}
