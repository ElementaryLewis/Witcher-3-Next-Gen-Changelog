package
{
   import flash.display.MovieClip;
   
   public dynamic class classBoatRace extends MovieClip
   {
       
      
      public function classBoatRace()
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
