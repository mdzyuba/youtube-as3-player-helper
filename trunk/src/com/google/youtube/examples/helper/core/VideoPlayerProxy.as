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

  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.events.Event;

  /**
   * A proxy to the YouTube AS3 Player object.
   */
  public class VideoPlayerProxy extends Sprite {
    private var player:Object;

    public function VideoPlayerProxy(playerContent:DisplayObject) {
      player = playerContent;
      addChild(playerContent);
      addEventListener(Event.RESIZE, onResize);
    }

    /**
     * Adds a listener function for the specified event.
     *
     * @param type is defined in PlayerEvent class.
     * @param listener of the event.
     */
    public override function addEventListener(type:String, listener:Function,
        useCapture:Boolean = false, priority:int = 0,
        useWeakReference:Boolean = false):void {
        player.addEventListener(type, listener, useCapture, priority,
            useWeakReference);
    }

    /**
     * Removes a listener function for the specified event.
     *
     * @param type is defined in PlayerEvent class.
     * @param listener of the event.
     */
    public override function removeEventListener(type:String, listener:Function,
        useCapture:Boolean = false):void {
        player.removeEventListener(type, listener, useCapture);
    }

    /**
     * Loads the specified video's thumbnail and prepares the player to play
     * the video. The player does not request the FLV until playVideo() or
     * seekTo() is called. When the video is cued and ready to play, the player
     * will broadcast a video cued event.
     *
     * @param videoId       video id to cue.
     * @param startSeconds  optional initial playback offset, i.e. the time
     *    from which the video should start playing when playVideo() is called.
     *    If you specify a startSeconds value and then call seekTo(), then the
     *    player plays from the time specified in the seekTo() call.
     * @param quality       optional initial playback quality.
     */
    public function cueVideoById(videoId:String, startSeconds:Number = 0,
        quality:String = null):void {
      player.cueVideoById(videoId, startSeconds, objectToString(quality));
    }

    /**
     * Loads the specified video's thumbnail and prepares the player to play
     * the video. The player does not request the FLV until playVideo() or
     * seekTo() is called. When the video is cued and ready to play, the
     * player will broadcast a video cued event.
     *
     * @param mediaContentUrl  a fully qualified YouTube player URL in the
     *  format http://www.youtube.com/v/VIDEO_ID.
     * @param startSeconds  optional initial playback offset, i.e. the time
     *  from which the video should start playing when playVideo() is called.
     *  If you specify a startSeconds value and then call seekTo(), then the
     *  player plays from the time specified in the seekTo() call.
     * @param quality optional initial playback quality.
     */
    public function cueVideoByUrl(mediaContentUrl:String,
        startSeconds:Number = 0, quality:String = null):void {
      player.cueVideoByUrl(mediaContentUrl, startSeconds,
          objectToString(quality));
    }

    /**
     * Returns the elapsed time in seconds since the video started playing.
     * @return time in seconds.
     */
    public function getCurrentTime():Number {
      return player.getCurrentTime();
    }

    /**
     * Returns the duration in seconds of the currently playing video.
     * Note that getDuration() will return 0 until the video's metadata is
     * loaded, which normally happens just after the video starts playing.
     *
     * @return the duration of the video in seconds.
     */
    public function getDuration():Number {
      return player.getDuration();
    }

    /**
     * Loads and plays the specified video.
     *
     * @param videoId       video id to load and play.
     * @param startSeconds  optional initial playback offset, in seconds.
     *  If it is specified, then the video will start from the closest keyframe
     *  to the specified time.
     * @param quality       optional initial playback quality. Please see the
     *  definition of the setPlaybackQuality function for more information
     *  about playback quality.
     */
    public function loadVideoById(videoId:String, startSeconds:Number = 0,
        quality:String = null):void {
      player.loadVideoById(videoId, startSeconds, quality);
    }

    /**
     * Loads and plays the specified video.
     *
     * @param mediaContentUrl  a fully qualified YouTube player URL in the
     *  format http://www.youtube.com/v/VIDEO_ID.
     * @param startSeconds  optional initial playback offset, i.e. the time
     *  from which the video should start playing when playVideo() is called.
     *  If you specify a startSeconds value and then call seekTo(), then the
     *  player plays from the time specified in the seekTo() call.
     * @param quality optional initial playback quality. Please see the
     *  definition of the setPlaybackQuality function for more information
     *  about playback quality.
     */
    public function loadVideoByUrl(mediaContentUrl:String,
        startSeconds:Number = 0, quality:String = null):void {
      player.loadVideoByUrl(mediaContentUrl, startSeconds, quality);
    }

    /**
     * Pauses the currently playing video. The final player state after this
     * function executes will be paused (2) unless the player is in the ended
     * (0) state when the function is called, in which case the player state
     * will not change.
     */
    public function pauseVideo():void {
      player.pauseVideo();
    }

    /**
     * Plays the currently cued/loaded video. The final player state after this
     * function executes will be playing (1).
     */
    public function playVideo():void {
      player.playVideo();
    }

    /**
     * Stops and cancels loading of the current video. This function should be
     * reserved for rare situations when you know that the user will not be
     * watching additional video in the player. If your intent is to pause the
     * video, you should just call the pauseVideo function. If you want to
     * change the video that the player is playing, you can call one of the
     * queueing functions without calling stopVideo first.
     *
     * Important: Unlike the pauseVideo function, which leaves the player in
     * the paused (2) state, the stopVideo function could put the player into
     * any not-playing state, including ended (0), paused (2), video cued (5)
     * or unstarted (-1).
     */
    public function stopVideo():void {
      player.stopVideo();
    }

    /**
     * Seeks to a specified time in the video.
     *
     * The final player state after this function executes will be playing (1)
     * unless the value of the seconds parameter is greater than the video
     * length, in which case the final player state will be ended (0).
     *
     * @param seconds identifies the time from which the video should start
     *  playing. If the player has already buffered the portion of the video
     *  to which the user is advancing, then the player will start playing
     *  the video at the closest keyframe to the specified time. This behavior
     *  is governed by the seek() method of the Flash player's NetStream object.
     *  In practice, this means that the player could advance to a keyframe
     *  just before or just after the specified time. (For more information,
     *  see Adobe's documentation for the NetStream class.)
     *  If the player has not yet buffered the portion of the video to which the
     *  user is seeking, then the player will start playing the video at the
     *  closest keyframe before the specified time.
     * @param allowSeekAhead determines whether the player will make a new
     *  request to the server if the seconds parameter specifies a time outside
     *  of the currently buffered video data. We recommend that you set this
     *  parameter to false while the user is dragging the mouse along a video
     *  progress bar and then set the parameter to true when the user releases
     *  the mouse. This approach lets the user scroll to different points of
     *  the video without requesting new video streams by scrolling past
     *  unbuffered points in the video. Then, when the user releases the mouse
     *  button, the player will advance to the desired point in the video,
     *  only requesting a new video stream if the user is seeking to an
     *  unbuffered point in the stream.
     */
    public function seekTo(seconds:Number = 0,
        allowSeekAhead:Boolean = true):void {
      player.seekTo(seconds, allowSeekAhead);
    }

    /**
     * Sets the suggested video quality for the current video.
     *
     * The function causes the video to reload at its current position in the
     * new quality. If the playback quality does change, it will only change
     * for the video being played. Calling this function does not guarantee
     * that the playback quality will actually change. However, if the playback
     * quality does change, the onPlaybackQualityChange event will fire,
     * and your code should respond to the event rather than the fact that
     * it called the setPlaybackQuality function.
     *
     * The suggestedQuality parameter value can be small, medium, large, hd720,
     * hd1080, highres or default. We recommend that you set the parameter
     * value to default, which instructs YouTube to select the most appropriate
     * playback quality, which will vary for different users, videos, systems
     * and other playback conditions.
     *
     * When you suggest a playback quality for a video, the suggested quality
     * will only be in effect for that video. You should select a playback
     * quality that corresponds to the size of your video player. For example,
     * if your page displays a 1280px by 720px video player, a hd720 quality
     * video will actually look better than an hd1080 quality video. We
     * recommend calling the getAvailableQualityLevels() function to determine
     * which quality levels are available for a video.
     *
     * @see http://code.google.com/apis/youtube/flash_api_reference.html
     */
    public function setPlaybackQuality(quality:String):void {
      player.setPlaybackQuality(quality);
    }

    /**
     * Mutes the player.
     */
    public function mute():void {
      player.mute();
    }

    /**
     * Unmutes the player.
     */
    public function unmute():void {
      player.unMute();
    }

    /**
     * @return true if the player is muted, false if not.
     */
    public function isMuted():Boolean {
      return player.isMuted();
    }

    /**
     * Sets the volume.
     *
     * @param volume  an integer between 0 and 100.
     */
    public function setVolume(volume:Number):void {
      player.setVolume(volume);
    }

    /**
     * @return the player's current volume, an integer between 0 and 100.
     * Note that getVolume() will return the volume even if the player is muted.
     */
    public function getVolume():Number {
      return player.getVolume();
    }

    /**
     * Sets the size in pixels of the player. This method should be used
     * instead of setting the width and height properties of the MovieClip.
     * Note that this method does not constrain the proportions of the video
     * player, so you will need to maintain a 4:3 aspect ratio.
     * The default size of the chromeless SWF when loaded into another SWF is
     * 320px by 240px and the default size of the embedded player SWF is 480px
     * by 385px.
     *
     * @param width the width of the player.
     * @param height the height of the player.
     */
    public function setSize(width:Number, height:Number):void {
      player.setSize(width, height);
    }

    /**
     * @return the number of bytes loaded for the current video.
     */
    public function getVideoBytesLoaded():Number {
      return player.getVideoBytesLoaded();
    }

    /**
     * @return the size in bytes of the currently loaded/playing video.
     */
    public function getVideoBytesTotal():Number {
      return player.getVideoBytesTotal();
    }

    /**
     * @return the number of bytes the video file started loading from.
     *  Example scenario: the user seeks ahead to a point that hasn't loaded
     *  yet, and the player makes a new request to play a segment of the video
     *  that hasn't loaded yet.
     */
    public function getVideoStartBytes():Number {
      return player.getVideoStartBytes();
    }

    /**
     * @return the state of the player. Possible values are unstarted (-1),
     *  ended (0), playing (1), paused (2), buffering (3), video cued (5).
     */
    public function getPlayerState():Number {
      return player.getPlayerState();
    }

    /**
     * This function retrieves the actual video quality of the current video.
     *
     * @return "undefined" if there is no current video. Possible return values
     *  are "highres", "hd1080", "hd720", "large", "medium" and "small".
     */
    public function getPlaybackQuality():String {
      return player.getPlaybackQuality();
    }

    /**
     * This function returns the set of quality formats in which the current
     * video is available. You could use this function to determine whether
     * the video is available in a higher quality than the user is viewing,
     * and your player could display a button or other element to let
     * the user adjust the quality.
     *
     * The function returns an array of strings ordered from highest to
     * lowest quality. Possible array element values are highres, hd1080,
     * hd720, large, medium and small. This function returns an empty array
     * if there is no current video.
     *
     * @return an array of PlaybackQuality constants for the current video.
     */
    public function getAvailableQualityLevels():Array {
      return player.getAvailableQualityLevels();
    }

    /**
     * Returns the YouTube.com URL for the currently loaded/playing video.
     *
     * @return a URL of the current video.
     */
    public function getVideoUrl():String {
      return player.getVideoUrl();
    }

    /**
     * @return the embed code for the currently loaded/playing video.
     */
    public function getVideoEmbedCode():String {
      return player.getVideoEmbedCode();
    }

    /**
     * This function destroys the player instance. It should be called before
     * unloading the player SWF from your parent SWF.
     *
     * Important: You should always call player.destroy() to unload a YouTube
     * player. This function will close the NetStream object and stop additional
     * videos from downloading after the player has been unloaded. If your code
     * contains additional references to the player SWF, you also need to
     * destroy those references separately when you unload the player.
     */
    public function destroy():void {
      player.destroy();
    }

    private function onResize(event:Event):void {
      // stop the event because the player client is not interested in resize
      // events of embedded player controls.
      if (event.target != player) {
        event.stopPropagation();
      }
    }

    private function objectToString(o:Object):String {
      return o ? o.toString() : null;
    }

    public function get nestedPlayer():DisplayObject {
      return DisplayObject(player);
    }

    public function getDebugText():String {
      return player.getDebugText();
    }
  }
}
