package
{
   import flash.display.MovieClip;
   
   public dynamic class classAlchemic extends MovieClip
   {
       
      
      public function classAlchemic()
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