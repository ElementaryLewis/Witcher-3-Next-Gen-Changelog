package red.core.overlay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.geom.ColorTransform;
   import scaleform.gfx.Extensions;
   
   public class Blackscreen extends MovieClip
   {
       
      
      public var mcBlackscreen:MovieClip;
      
      private var lastFrameTimeInMS:int = 0;
      
      private var blackscreenAlphaAccel:Number = 0;
      
      public function Blackscreen()
      {
         super();
         addFrameScript(0,this.frame1);
         var _loc1_:String = "0x000000";
         if(Extensions.enabled)
         {
            _loc1_ = ExternalInterface.call("initString") as String;
         }
         trace("LoadingScreen initString: " + _loc1_);
         var _loc2_:uint = parseInt(_loc1_,16);
         trace("color: " + _loc2_);
         var _loc3_:ColorTransform = this.mcBlackscreen.transform.colorTransform;
         _loc3_.color = _loc2_;
         _loc3_.alphaOffset = 255;
         this.mcBlackscreen.transform.colorTransform = _loc3_;
         trace("Blackscreen color: " + this.mcBlackscreen.transform.colorTransform);
         if(!stage)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            this.registerLoadingScreen();
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this.registerLoadingScreen();
      }
      
      private function registerLoadingScreen() : void
      {
         trace("Blackscreen registerLoadingScreen");
         if(Extensions.enabled)
         {
            ExternalInterface.call("registerLoadingScreen",this);
         }
      }
      
      public function setPlatform(param1:uint) : void
      {
      }
      
      public function setVideoSubtitles(param1:String) : void
      {
      }
      
      public function setTipText(param1:String) : void
      {
      }
      
      public function showVideoSkip() : void
      {
      }
      
      public function hideVideoSkip() : void
      {
      }
      
      public function showImage() : void
      {
      }
      
      public function hideImage() : void
      {
      }
      
      public function fadeOut(param1:Number) : void
      {
         trace("fadeOut: " + param1);
         this.onFadeOutCompleted();
      }
      
      public function fadeIn(param1:Number) : void
      {
         trace("fadeIn");
         this.mcBlackscreen.visible = true;
         this.mcBlackscreen.alpha = 1;
      }
      
      private function onFadeOutCompleted() : void
      {
         trace("LoadingScreen fadeOutCompleted");
         if(Extensions.enabled)
         {
            ExternalInterface.call("fadeOutCompleted",this);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
