package panel_alchemy_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class progressbar2_27 extends MovieClip
   {
       
      
      public function progressbar2_27()
      {
         super();
         addFrameScript(0,this.frame1,30,this.frame31,47,this.frame48,63,this.frame64);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame31() : *
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      internal function frame48() : *
      {
         gotoAndStop("Idle");
      }
      
      internal function frame64() : *
      {
         gotoAndStop("Idle");
      }
   }
}
