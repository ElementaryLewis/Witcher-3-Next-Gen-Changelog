package red.engine
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.external.ExternalInterface;
   import flash.geom.ColorTransform;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import scaleform.gfx.Extensions;
   
   public class VideoPlayer extends MovieClip
   {
      
      private static const VIDEO_EVENT_STARTED:int = 0;
      
      private static const VIDEO_EVENT_STOPPED:int = 1;
      
      private static const VIDEO_EVENT_ERROR:int = 2;
       
      
      public var oVideo:Video;
      
      public var mcBackground:MovieClip;
      
      private var _netStream:NetStream;
      
      public var _NATIVE_onVideoEvent:Function;
      
      public var _NATIVE_onVideoSubtitles:Function;
      
      public var _NATIVE_onVideoCuePoint:Function;
      
      public var _NATIVE_onVideoMetaData:Function;
      
      public function VideoPlayer()
      {
         super();
         trace("VideoPlayer created");
         this.mcBackground.visible = false;
         var _loc1_:NetConnection = new NetConnection();
         _loc1_.connect(null);
         var _loc2_:Object = new Object();
         _loc2_.onCuePoint = this.handleCuePoint;
         _loc2_.onSubtitle = this.handleSubtitles;
         _loc2_.onMetaData = this.handleMetaData;
         this._netStream = new NetStream(_loc1_);
         this._netStream.client = _loc2_;
         this._netStream.addEventListener(NetStatusEvent.NET_STATUS,this.handleNetStatus,false,0,true);
         var _loc3_:SoundTransform = new SoundTransform(1);
         var _loc4_:SoundTransform = new SoundTransform(1);
         this._netStream.soundTransform = _loc3_;
         if(Extensions.enabled)
         {
            this._netStream["subSoundTransform"] = _loc4_;
         }
         this.oVideo.attachNetStream(this._netStream);
         if(!stage)
         {
            this.oVideo.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            this.registerVideoPlayer();
         }
      }
      
      public function _HOOK_playVideo(param1:String) : void
      {
         if(!stage)
         {
            throw new Error("Video not on stage yet!");
         }
         trace("VideoPlayer playVideo: " + param1);
         this.oVideo.clear();
         this._netStream.play(param1);
      }
      
      public function _HOOK_showBackground(param1:uint) : void
      {
         trace("_HOOK_showBackground color: " + param1);
         var _loc2_:ColorTransform = this.mcBackground.transform.colorTransform;
         _loc2_.color = param1;
         _loc2_.alphaOffset = 255;
         this.mcBackground.transform.colorTransform = _loc2_;
         trace("mcBackground color: " + this.mcBackground.transform.colorTransform);
         this.mcBackground.visible = true;
      }
      
      public function _HOOK_hideBackground() : void
      {
         trace("_HOOK_hideBackground");
         this.mcBackground.visible = false;
      }
      
      public function _HOOK_stopVideo() : void
      {
         trace("VideoPlayer stopVideo");
         this._netStream.close();
         this.oVideo.clear();
      }
      
      public function _HOOK_pauseVideo() : void
      {
         this._netStream.pause();
      }
      
      public function _HOOK_unpauseVideo() : void
      {
         this._netStream.resume();
      }
      
      public function _HOOK_clearVideo() : void
      {
         this.oVideo.clear();
      }
      
      public function onVideoEvent(param1:int) : void
      {
         if(this._NATIVE_onVideoEvent != null)
         {
            this._NATIVE_onVideoEvent(param1);
         }
      }
      
      public function onVideoSubtitles(param1:String) : void
      {
         if(this._NATIVE_onVideoSubtitles != null)
         {
            this._NATIVE_onVideoSubtitles(param1);
         }
      }
      
      public function onVideoCuePoint(param1:String) : void
      {
         if(this._NATIVE_onVideoCuePoint != null)
         {
            this._NATIVE_onVideoCuePoint(param1);
         }
      }
      
      public function onVideoMetaData(param1:String) : void
      {
         if(this._NATIVE_onVideoMetaData != null)
         {
            this._NATIVE_onVideoMetaData(param1);
         }
      }
      
      private function handleMetaData(param1:Object) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:* = null;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            _loc4_ = "" + _loc3_ + ": " + param1[_loc3_] + ", ";
            _loc2_ += _loc4_;
         }
         this.onVideoMetaData(_loc2_);
      }
      
      private function handleNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               this.onVideoEvent(VIDEO_EVENT_STARTED);
               break;
            case "NetStream.Play.Stop":
               this.onVideoEvent(VIDEO_EVENT_STOPPED);
               break;
            case "NetStream.Play.StreamNotFound":
            case "NetStream.Play.InternalError":
               this.onVideoEvent(VIDEO_EVENT_ERROR);
         }
      }
      
      private function handleSubtitles(param1:String) : void
      {
         this.onVideoSubtitles(param1);
      }
      
      private function handleCuePoint(param1:Object) : void
      {
         this.onVideoCuePoint(param1.name);
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.oVideo.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this.registerVideoPlayer();
      }
      
      private function registerVideoPlayer() : void
      {
         trace("VideoPlayer registerVideoPlayer");
         if(Extensions.enabled)
         {
            ExternalInterface.call("registerVideoPlayer",this,this._netStream);
         }
      }
   }
}
