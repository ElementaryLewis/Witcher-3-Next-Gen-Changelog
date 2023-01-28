package hud_quests_fla
{
   import flash.display.MovieClip;
   
   public dynamic class TutorialHighlight_11 extends MovieClip
   {
       
      
      public function TutorialHighlight_11()
      {
         super();
         addFrameScript(0,this.frame1,1,this.frame2);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame2() : *
      {
         stop();
      }
   }
}
