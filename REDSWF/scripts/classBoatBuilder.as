package
{
   import flash.display.MovieClip;
   
   public dynamic class classBoatBuilder extends MovieClip
   {
       
      
      public function classBoatBuilder()
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
