package
{
   import flash.display.MovieClip;
   
   public dynamic class classHorseRacingNPC extends MovieClip
   {
       
      
      public function classHorseRacingNPC()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
