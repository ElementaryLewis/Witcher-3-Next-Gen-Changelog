package red.game.witcher3.menus.common
{
   import flash.display.MovieClip;
   import flash.events.NetStatusEvent;
   import flash.media.SoundTransform;
   import flash.media.Video;
   import flash.net.NetConnection;
   import flash.net.NetStream;
   import red.core.events.GameEvent;
   import scaleform.clik.core.UIComponent;
   import scaleform.gfx.Extensions;
   
   public class W3VideoObject extends UIComponent
   {
       
      
      public var video:MovieClip;
      
      private var ns:NetStream;
      
      private var videoToPlay:String;
      
      public function W3VideoObject()
      {
         super();
      }
      
      override protected function configUI() : void
      {
         super.configUI();
         this.update();
      }
      
      private function update() : *
      {
      }
      
      public function OpenVideo(param1:String, param2:Boolean) : *
      {
         this.videoToPlay = param1;
         var _loc3_:Video = new Video(this.video.width,this.video.height);
         this.video.addChild(_loc3_);
         var _loc4_:NetConnection;
         (_loc4_ = new NetConnection()).connect(null);
         this.ns = new NetStream(_loc4_);
         _loc3_.attachNetStream(this.ns);
         var _loc5_:Object;
         (_loc5_ = new Object()).onMetaData = this.handleMetaDataEvent;
         _loc5_.onCuePoint = this.handleCuePointEvent;
         _loc5_.onSubtitle = this.handleSubtitleEvent;
         this.ns.client = _loc5_;
         var _loc6_:SoundTransform = new SoundTransform(1);
         var _loc7_:SoundTransform = new SoundTransform(1);
         this.ns.soundTransform = _loc6_;
         if(Extensions.enabled)
         {
            this.ns["subSoundTransform"] = _loc7_;
         }
         this.ns.bufferTime = 1.5;
         if(Extensions.isScaleform)
         {
            this.ns["loop"] = param2;
         }
         this.ns.play(this.videoToPlay);
         this.ns.addEventListener(NetStatusEvent.NET_STATUS,this.statusHandler);
      }
      
      internal function statusHandler(param1:NetStatusEvent) : void
      {
         if(param1.info.code == "NetStream.Play.Start")
         {
         }
         if(param1.info.code == "NetStream.Play.Stop")
         {
            dispatchEvent(new GameEvent(GameEvent.CALL,"OnSkipMovie"));
         }
      }
      
      internal function handleMetaDataEvent(param1:Object) : void
      {
         if(!param1)
         {
         }
      }
      
      internal function handleCuePointEvent(param1:Object) : void
      {
         var _loc2_:String = null;
         if(param1)
         {
            for(_loc2_ in param1.parameters)
            {
            }
         }
      }
      
      internal function handleSubtitleEvent(param1:String) : *
      {
         if(!param1)
         {
         }
      }
      
      public function PauseVideo() : void
      {
         this.ns.togglePause();
      }
      
      public function SetSoundVolume(param1:Number) : *
      {
         var _loc2_:SoundTransform = new SoundTransform(param1);
         var _loc3_:SoundTransform = new SoundTransform(param1);
         this.ns.soundTransform = _loc2_;
         if(Extensions.enabled)
         {
            this.ns["subSoundTransform"] = _loc3_;
         }
      }
   }
}
