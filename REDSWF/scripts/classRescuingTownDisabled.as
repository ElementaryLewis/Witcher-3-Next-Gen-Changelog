package
{
   import flash.display.MovieClip;
   
   public dynamic class classRescuingTownDisabled extends MovieClip
   {
       
      
      public function classRescuingTownDisabled()
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
