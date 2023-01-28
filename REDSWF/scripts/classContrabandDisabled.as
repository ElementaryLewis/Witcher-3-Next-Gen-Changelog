package
{
   import flash.display.MovieClip;
   
   public dynamic class classContrabandDisabled extends MovieClip
   {
       
      
      public function classContrabandDisabled()
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
