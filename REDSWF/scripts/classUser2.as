package
{
   import flash.display.MovieClip;
   
   public dynamic class classUser2 extends MovieClip
   {
       
      
      public function classUser2()
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
