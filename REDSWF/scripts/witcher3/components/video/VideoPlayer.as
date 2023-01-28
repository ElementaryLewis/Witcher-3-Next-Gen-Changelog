package witcher3.components.video
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.NetStatusEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import scaleform.gfx.Extensions;
   import witcher3.game.GameInterface;
   import witcher3.game.data.VideoData;
   
   public class VideoPlayer extends MovieClip
   {
       
      
      public var oVideo:Video;
      
      private var _playingVideoData:VideoData;
      
      private var _playQueue:Vector.<VideoData>;
      
      private var _netStream:NetStream;
      
      public var _gfxFuncSetSubtitleImpl:Object;
      
      public var _gfxFuncFinishedCallbackImpl:Object;
      
      public function VideoPlayer()
      {
         this._playQueue = new Vector.<VideoData>();
         super();
         GameInterface.initialize();
         var _loc1_:NetConnection = new NetConnection();
         _loc1_.connect(null);
         var _loc2_:Object = new Object();
         _loc2_.onCuePoint = this.handleCuePoint;
         _loc2_.onSubtitle = this.handleSubtitle;
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
         this.oVideo.addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
      }
      
      public function playVideo(param1:VideoData, param2:Boolean = false) : void
      {
         if(!param1)
         {
            return;
         }
         if(param2)
         {
            this._playQueue.length = 0;
            this.stopVideo();
         }
         this._playQueue.push(param1);
         if(Boolean(stage) || !this._playingVideoData)
         {
            this.requestPlayNextVideo();
         }
      }
      
      public function stopVideo() : void
      {
         this.requestStopVideo();
      }
      
      public function pauseVideo() : void
      {
         this._netStream.pause();
      }
      
      public function unpauseVideo() : void
      {
         this._netStream.resume();
      }
      
      private function requestStopVideo() : void
      {
         this._netStream.close();
         this.oVideo.clear();
      }
      
      private function requestPlayNextVideo() : void
      {
         if(this._playingVideoData)
         {
            throw new Error("Must wait for the current video to stop playing first!");
         }
         this.oVideo.clear();
         if(this._playQueue.length > 0)
         {
            this._playingVideoData = this._playQueue.shift();
            this._netStream.play(this._playingVideoData.filePath);
         }
         else if(this._gfxFuncFinishedCallbackImpl != null)
         {
            this._gfxFuncFinishedCallbackImpl();
         }
      }
      
      private function handleMetaData(param1:Object) : void
      {
      }
      
      private function handleCuePoint(param1:Object) : void
      {
      }
      
      private function handleNetStatus(param1:NetStatusEvent) : void
      {
         switch(param1.info.code)
         {
            case "NetStream.Play.Start":
               if(Extensions.enabled)
               {
                  this._netStream["audioTrack"] = 0;
                  this._netStream["subtitleTrack"] = this._playingVideoData.textTrack;
                  this._netStream["subAudioTrack"] = this._playingVideoData.audioTrack;
               }
               break;
            case "NetStream.Play.Stop":
            case "NetStream.Play.StreamNotFound":
               this._playingVideoData = null;
               this.requestPlayNextVideo();
         }
      }
      
      public function handleSubtitle(param1:String) : void
      {
         if(this._gfxFuncSetSubtitleImpl != null)
         {
            this._gfxFuncSetSubtitleImpl(param1);
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         this.oVideo.removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         GameInterface.sendDisplayObject(this,"VideoPlayer");
         if(!this._playingVideoData)
         {
            this.requestPlayNextVideo();
         }
      }
   }
}
