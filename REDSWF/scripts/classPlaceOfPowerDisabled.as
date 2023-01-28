package
{
   import flash.display.MovieClip;
   
   public dynamic class classPlaceOfPowerDisabled extends MovieClip
   {
       
      
      public function classPlaceOfPowerDisabled()
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
