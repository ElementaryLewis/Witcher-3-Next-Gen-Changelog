package
{
   import flash.display.MovieClip;
   
   public dynamic class classContrabandShipDisabled extends MovieClip
   {
       
      
      public function classContrabandShipDisabled()
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
