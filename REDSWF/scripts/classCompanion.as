package
{
   import flash.display.MovieClip;
   
   public dynamic class classCompanion extends MovieClip
   {
       
      
      public function classCompanion()
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
