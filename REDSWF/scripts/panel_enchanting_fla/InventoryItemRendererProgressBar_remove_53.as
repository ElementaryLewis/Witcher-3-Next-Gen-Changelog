package panel_enchanting_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class InventoryItemRendererProgressBar_remove_53 extends MovieClip
   {
       
      
      public function InventoryItemRendererProgressBar_remove_53()
      {
         super();
         addFrameScript(0,this.frame1,11,this.frame12,20,this.frame21);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame12() : *
      {
         dispatchEvent(new Event("sound_trigger_event"));
      }
      
      internal function frame21() : *
      {
         dispatchEvent(new Event(Event.COMPLETE));
         gotoAndStop(1);
      }
   }
}
