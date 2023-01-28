package
{
   import flash.display.MovieClip;
   
   public dynamic class classNotDiscoveredPOI extends MovieClip
   {
       
      
      public function classNotDiscoveredPOI()
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
