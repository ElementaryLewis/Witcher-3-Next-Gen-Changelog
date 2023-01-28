package deck_builder_fla
{
   import flash.display.MovieClip;
   
   public dynamic class DeckStatsHighlight_20 extends MovieClip
   {
       
      
      public function DeckStatsHighlight_20()
      {
         super();
         addFrameScript(0,this.frame1,20,this.frame21);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame21() : *
      {
         gotoAndStop(1);
      }
   }
}
