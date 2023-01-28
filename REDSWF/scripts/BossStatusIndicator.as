package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class BossStatusIndicator extends StatusIndicator
   {
       
      
      public function BossStatusIndicator()
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
