package
{
   import flash.display.MovieClip;
   
   public dynamic class classRoadSign extends MovieClip
   {
       
      
      public function classRoadSign()
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
