package
{
   import flash.display.MovieClip;
   
   public dynamic class classHideoutDisabled extends MovieClip
   {
       
      
      public function classHideoutDisabled()
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
