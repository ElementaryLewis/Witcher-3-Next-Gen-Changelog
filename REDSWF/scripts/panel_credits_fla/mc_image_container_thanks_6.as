package panel_credits_fla
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import red.game.witcher3.menus.mainmenu.CreditsMenu;
   
   public dynamic class mc_image_container_thanks_6 extends MovieClip
   {
       
      
      public var mcThankYouNote:MovieClip;
      
      public function mc_image_container_thanks_6()
      {
         super();
         addFrameScript(0,this.frame1,133,this.frame134,1294,this.frame1295);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame134() : *
      {
         dispatchEvent(new Event(CreditsMenu.STOP_VIDEO));
      }
      
      internal function frame1295() : *
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}
