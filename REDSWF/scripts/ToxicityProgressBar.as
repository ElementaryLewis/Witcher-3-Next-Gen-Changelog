package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class ToxicityProgressBar extends StatusIndicator
   {
       
      
      public function ToxicityProgressBar()
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
