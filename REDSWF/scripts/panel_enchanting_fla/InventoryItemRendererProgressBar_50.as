package panel_enchanting_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class InventoryItemRendererProgressBar_50 extends MovieClip
   {
       
      
      public function InventoryItemRendererProgressBar_50()
      {
         super();
         addFrameScript(0,this.frame1,15,this.frame16,25,this.frame26);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame16() : *
      {
         dispatchEvent(new Event("sound_trigger_event"));
      }
      
      internal function frame26() : *
      {
         dispatchEvent(new Event(Event.COMPLETE));
         gotoAndStop(1);
      }
   }
}
