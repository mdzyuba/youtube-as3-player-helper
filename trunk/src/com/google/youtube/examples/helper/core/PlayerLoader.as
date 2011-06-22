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

  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SecurityErrorEvent;
  import flash.net.URLRequest;
  import flash.net.URLVariables;
  import flash.system.ApplicationDomain;
  import flash.system.LoaderContext;
  import flash.system.Security;

  [Event(name = "playerLoaderReady",
      type = "com.google.youtube.examples.helper.core.PlayerEvent")]
  [Event(name = "playerLoaderError",
      type = "com.google.youtube.examples.helper.core.PlayerEvent")]

  public class PlayerLoader extends EventDispatcher {
    public static const CHROMELESS_VIDEO_PLAYER_URL:String =
        "http://www.youtube.com/apiplayer";
    public static const EMBEDDED_PLAYER_URL:String =
        "http://www.youtube.com/v/";
    public var chromelessVideoPlayerUrl:String = CHROMELESS_VIDEO_PLAYER_URL;
    private var embeddedPlayerURLValue:String = EMBEDDED_PLAYER_URL;
    private var playerValue:VideoPlayerProxy;

    // Adding s.ytimg.com to prevent Security Sandbox Violation errors
    private var secureDomains:Array = [
      "www.youtube.com",
      "s.youtube.com",
      "s.ytimg.com",
      "ytimg.com"
    ];
    private var contentLoader:Loader;

    public function PlayerLoader() {
      allowDomains();
      contentLoader = new Loader();
      contentLoader.contentLoaderInfo.addEventListener(Event.INIT,
          onLoaderInit);
      contentLoader.contentLoaderInfo.addEventListener(
          SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }

    public function loadChromelessVideoPlayer():void {
      loadPlayer(chromelessVideoPlayerUrl);
    }

    public function loadEmbeddedVideoPlayer(videoID:String):void {
      var url:String = getEmbeddedPlayerUrl(videoID);
      loadPlayer(url);
    }

    private function loadPlayer(url:String):void {
      var request:URLRequest = new URLRequest(url);
      var variables:URLVariables = createPlayerUrlVariables();
      request.data = variables;
      var context:LoaderContext = new LoaderContext(true,
          ApplicationDomain.currentDomain);
      contentLoader.load(request, context);
    }

    private function createPlayerUrlVariables():URLVariables {
      var variables:URLVariables = new URLVariables();
      variables.version = 3;
      return variables;
    }

    public function setSize(width:Number, height:Number):void {
      player.setSize(width, height);
    }

    public function get player():VideoPlayerProxy {
      return playerValue;
    }

    public function unload():void {
      player.destroy();
      contentLoader.unload();
    }

    public function allowDomains():void {
      for each (var domain:String in youtubeDomains) {
        Security.allowDomain(domain);
      }
    }

    private function onLoaderInit(event:Event):void {
      contentLoader.content.addEventListener(PlayerEvent.PLAYER_IS_READY,
          onPlayerReady);
      contentLoader.content.addEventListener(PlayerEvent.ERROR,
          onPlayerError);
    }

    private function onPlayerReady(event:Event):void {
      playerValue = new VideoPlayerProxy(contentLoader.content);
      dispatchEvent(new PlayerEvent(PlayerEvent.PLAYER_IS_READY, event));
    }

    private function onPlayerError(event:Event):void {
      dispatchEvent(new PlayerEvent(PlayerEvent.ERROR,
          event));
    }

    private function onSecurityError(event:Event):void {
      dispatchEvent(new PlayerEvent(PlayerEvent.ERROR,
          event));
    }

    public function get youtubeDomains():Array {
      return secureDomains;
    }

    public function set youtubeDomains(value:Array):void {
      secureDomains = value;
    }

    public function getEmbeddedPlayerUrl(videoID:String):String {
      var url:String = embeddedPlayerURLValue + videoID;
      return url;
    }

    public function set embeddedPlayerURL(value:String):void {
      embeddedPlayerURLValue = value;
    }
  }
}
