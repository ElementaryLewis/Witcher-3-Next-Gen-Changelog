package red.engine
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.text.TextField;
   import scaleform.gfx.Extensions;
   
   public class VideoDebugHud extends MovieClip
   {
       
      
      public var tfTitle:TextField;
      
      public var tfMetadata:TextField;
      
      public var tfCuePoint:TextField;
      
      public var tfSubtitles:TextField;
      
      public function VideoDebugHud()
      {
         super();
         addFrameScript(0,this.frame1);
         if(!stage)
         {
            addEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false,0,true);
         }
         else
         {
            this.registerVideoDebugHud();
         }
      }
      
      private function handleAddedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.handleAddedToStage,false);
         this.registerVideoDebugHud();
      }
      
      private function registerVideoDebugHud() : void
      {
         trace("VideoDebugHud registerVideoDebugHud");
         if(Extensions.enabled)
         {
            ExternalInterface.call("registerVideoDebugHud",this);
         }
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
