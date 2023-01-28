package
{
   import flash.display.MovieClip;
   
   public dynamic class MouseCursorRef extends MovieClip
   {
       
      
      public function MouseCursorRef()
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
