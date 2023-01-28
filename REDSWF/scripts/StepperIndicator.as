package
{
   import flash.display.MovieClip;
   
   public dynamic class StepperIndicator extends MovieClip
   {
       
      
      public function StepperIndicator()
      {
         super();
         addFrameScript(0,this.frame1,19,this.frame20);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame20() : *
      {
         stop();
      }
   }
}
