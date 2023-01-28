package
{
   import flash.display.MovieClip;
   
   public dynamic class classArmorer extends MovieClip
   {
       
      
      public function classArmorer()
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
