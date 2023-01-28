package
{
   import flash.display.MovieClip;
   
   public dynamic class classUser1 extends MovieClip
   {
       
      
      public function classUser1()
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
