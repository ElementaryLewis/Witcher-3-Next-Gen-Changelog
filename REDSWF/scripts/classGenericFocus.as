package
{
   import flash.display.MovieClip;
   
   public dynamic class classGenericFocus extends MovieClip
   {
       
      
      public function classGenericFocus()
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
