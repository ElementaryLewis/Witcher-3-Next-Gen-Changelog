package
{
   import flash.display.MovieClip;
   
   public dynamic class classHorseRace extends MovieClip
   {
       
      
      public function classHorseRace()
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
