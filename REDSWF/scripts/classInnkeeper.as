package
{
   import flash.display.MovieClip;
   
   public dynamic class classInnkeeper extends MovieClip
   {
       
      
      public function classInnkeeper()
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
