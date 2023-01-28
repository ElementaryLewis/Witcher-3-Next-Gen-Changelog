package
{
   import flash.display.MovieClip;
   
   public dynamic class classHideout extends MovieClip
   {
       
      
      public function classHideout()
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
