package red.core.overlay
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.utils.getTimer;
   import scaleform.clik.controls.StatusIndicator;
   import scaleform.gfx.Extensions;
   
   public class LoadingOverlay extends MovieClip
   {
      
      private static const SPINNER_ANIMATION_LIMIT:int = 25000;
       
      
      public var mcProgressBar:StatusIndicator;
      
      public var mcLoading:MovieClip;
      
      private var lastFrameTimeInMS:int = 0;
      
      private var alphaAccel:Number = 0;
      
      private var spinnerAnimationTime:int = 0;
      
      private var currentProgress:Number = 0;
      
      private var displayFakeProgress:Boolean = false;
      
      public function LoadingOverlay()
      {
         super();
         this.mcProgressBar.visible = false;
         this.mcProgressBar.minimum = 0;
         this.mcProgressBar.maximum = 1;
         this.mcProgressBar.validateNow();
         this.mcLoading.visible = false;
         this.mcLoading.alpha = 0;
         if(!stage)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            this.registerLoadingOverlay();
         }
      }
      
      public function setProgressValue(param1:Number) : void
      {
         this.mcProgressBar.value = param1;
      }
      
      public function showProgressBar(param1:Boolean) : void
      {
         this.mcProgressBar.visible = param1;
      }
      
      public function fadeIn(param1:Number) : void
      {
         trace("LoadingOverlay fadeIn: " + param1);
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
         if(param1 <= 0)
         {
            this.mcLoading.alpha = 1;
            this.mcLoading.visible = true;
         }
         else
         {
            this.mcLoading.alpha = 0;
            this.mcLoading.visible = true;
            this.alphaAccel = 1 / param1;
            this.lastFrameTimeInMS = getTimer();
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
      }
      
      public function fadeOut(param1:Number) : void
      {
         trace("LoadingOverlay fadeOut: " + param1);
         removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
         if(param1 <= 0)
         {
            this.mcLoading.alpha = 0;
            this.mcLoading.visible = false;
         }
         else
         {
            this.mcLoading.alpha = 1;
            this.mcLoading.visible = true;
            this.alphaAccel = -1 / param1;
            this.lastFrameTimeInMS = getTimer();
            addEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false,0,true);
         }
      }
      
      private function handleEnterFrame(param1:Event) : void
      {
         var _loc2_:int = getTimer();
         var _loc3_:Number = (_loc2_ - this.lastFrameTimeInMS) / 1000;
         this.mcLoading.alpha += _loc3_ * this.alphaAccel;
         if(this.alphaAccel < 0 && this.mcLoading.alpha <= 0)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
            this.mcLoading.visible = false;
            this.mcLoading.alpha = 0;
            trace("LoadingOverlay finish fadeOut");
         }
         else if(this.alphaAccel > 0 && this.mcLoading.alpha >= 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.handleEnterFrame,false);
            this.mcLoading.visible = true;
            this.mcLoading.alpha = 1;
            trace("LoadingOverlay finish fadeIn");
         }
         this.lastFrameTimeInMS = _loc2_;
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this.registerLoadingOverlay();
      }
      
      private function registerLoadingOverlay() : void
      {
         trace("LoadingOverlay registerLoadingOverlay");
         if(Extensions.enabled)
         {
            ExternalInterface.call("registerLoadingOverlay",this);
         }
      }
   }
}
