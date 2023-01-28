package panel_blacksmith_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   
   public dynamic class progressbar_rectangle_dismantle_54 extends MovieClip
   {
       
      
      public function progressbar_rectangle_dismantle_54()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14,20,this.frame21);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame14() : *
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
      
      internal function frame21() : *
      {
         gotoAndStop("start");
      }
   }
}
