package panel_character_fla
{
   import flash.display.MovieClip;
   
   public dynamic class dataChangedFeedback_43 extends MovieClip
   {
       
      
      public function dataChangedFeedback_43()
      {
         super();
         addFrameScript(0,this.frame1,4,this.frame5,22,this.frame23);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame5() : *
      {
         stop();
      }
      
      internal function frame23() : *
      {
         gotoAndStop("idle");
      }
   }
}
