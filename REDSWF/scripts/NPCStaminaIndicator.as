package
{
   import scaleform.clik.controls.StatusIndicator;
   
   public dynamic class NPCStaminaIndicator extends StatusIndicator
   {
       
      
      public function NPCStaminaIndicator()
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
