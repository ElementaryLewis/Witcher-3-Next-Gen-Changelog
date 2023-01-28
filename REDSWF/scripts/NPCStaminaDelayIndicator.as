package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class NPCStaminaDelayIndicator extends StatusIndicator
   {
       
      
      public function NPCStaminaDelayIndicator()
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
